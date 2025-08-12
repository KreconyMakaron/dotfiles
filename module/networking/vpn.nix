{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.preferences;
  vpnScript = builtins.readFile ./vpn.sh;

  serverOpts = {...}: {
    options = {
      publicKey = mkOption {
        type = types.str;
        default = "";
      };
      autostart = mkOption {
        type = types.bool;
        default = false;
      };
      endpoint = mkOption {
        type = types.str;
        default = "";
        example = "255.255.255.255:12345";
      };
    };
  };
in {
  options.preferences = {
    vpn = {
      enable = mkEnableOption "enables the vpn";
      disabledIPs = mkOption {
        type = types.listOf types.str;
        default = [];
      };
      privateKeyDir = mkOption {
        type = types.str;
        default = "/root/vpn-keys";
        example = "path/to/keys";
      };
      dns = mkOption {
        type = types.listOf types.str;
        default = "1.1.1.1";
      };
      address = mkOption {
        type = types.listOf types.str;
        default = ["1.1.1.1"];
      };
      servers = mkOption {
        type = types.attrsOf (types.submodule serverOpts);
        default = {};
        example = {
          server1 = {
            autostart = true;
            pubKey = "11111111111111111111111111111111111111111111";
            endpoint = "255.255.255.255:12345";
          };
        };
        description = ''
          List of server definitions.
          The key to each server is expected to be a file <privateKeyDir>/<server name>
        '';
      };
    };
  };

  config = mkIf cfg.vpn.enable {
    systemd.services.NetworkManager-wait-online.enable = false;

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "vpn" vpnScript)
    ];

    networking = {
      wg-quick.interfaces = let
        IPs = concatStringsSep " " cfg.vpn.disabledIPs;
        tableID = "200";

        mkInterface = name: values:
          nameValuePair name {
            inherit (values) autostart;
            inherit (cfg.vpn) dns address;
            privateKeyFile = "${cfg.vpn.privateKeyDir}/${name}";
            listenPort = 51820;
            mtu = 1280;

            peers = [
              {
                inherit (values) publicKey endpoint;
                allowedIPs = ["0.0.0.0/0" "::/0"];
              }
            ];

            preUp = ''
              set -euo pipefail

              gw=$(ip -4 route show default | ${getExe' pkgs.gawk "awk"} '/default/ {print $3; exit}') || gw=""
              dev=$(ip -4 route show default | ${getExe' pkgs.gawk "awk"} '/default/ {print $5; exit}') || dev=""

              if [ -n "$gw" ] && [ -n "$dev" ]; then
                ip route flush table ${tableID} || true
                ip route add default via "$gw" dev "$dev" table ${tableID}
              else
                echo "Error: no IPv4 default gateway found before VPN — cannot set exclusion table" >&2
                exit 1
              fi
            '';

            postUp = ''
              set -euo pipefail

              for ip in ${IPs}; do
                ip rule add to "$ip"/32 lookup ${tableID} priority 100 || true
              done
            '';

            postDown = ''
              set -euo pipefail

              for ip in ${IPs}; do
                ip rule del to "$ip"/32 lookup ${tableID} priority 100 || true
              done

              ip route flush table ${tableID} || true
            '';
          };
      in
        attrsets.mapAttrs' mkInterface cfg.vpn.servers;
    };
  };
}
