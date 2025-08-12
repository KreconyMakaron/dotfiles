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

            preUp = /* bash */ ''
              set -euo pipefail

              # save gateway and device to /run so PostUp can read them
              gw=$(ip -4 route show default | ${getExe' pkgs.gawk "awk"} '/default/ {print $3; exit}') || gw=""
              dev=$(ip -4 route show default | ${getExe' pkgs.gawk "awk"} '/default/ {print $5; exit}') || dev=""

              if [ -n "$gw" ] && [ -n "$dev" ]; then
                echo "$gw $dev" > /run/wg0-gw
              else
                # no default route found — handle as needed
                echo "NO_GW" > /run/wg0-gw
              fi
            '';

            postUp = /* bash */ ''
              set -euo pipefail
              read gw dev < /run/wg0-gw
              [ "$gw" = "NO_GW" ] && exit 1

              for ip in ${IPs}; do
                ip route add "''${ip}/32" via "$gw" dev "$dev" || true
              done
            '';

            postDown = /* bash */ ''
              set -euo pipefail
              read gw dev < /run/wg0-gw
              [ "$gw" = "NO_GW" ] && exit 0

              for ip in ${IPs}; do
                ip route del "''${ip}/32" via "$gw" dev "$dev" || true
              done

              rm -f /run/wg0-gw
            '';
          };
      in attrsets.mapAttrs' mkInterface cfg.vpn.servers;
    };
  };
}
