{ config, pkgs, lib, ...}:
with lib; let
  cfg = config.preferences;

  vpnScript = ''

    usage="usage: $0 [ connect | disconnect | interfaces ]" 

    if [[ $# -lt 1 ]]; then
      echo "$usage"
      exit 1
    fi

    if [ "$EUID" -ne 0 ]
      then echo "Please run as root"
      exit
    fi

    current_interface=$(wg | grep interface | awk -F: '{ print $2 }')
    current_interface="''${current_interface:1}"

    get_servers() {
      echo "$(systemctl list-unit-files | grep "wg-quick-*" | awk -F'wg-quick-' '{ print $2 }' | awk -F'.' '{ print $1 }')"
    }

    check_if_exists() {
      get_servers | grep $1 &>/dev/null
    }

    case "$1" in
      connect)
        if [[ $# -ne 2 ]]; then
          echo "usage: vpn connect <interface>"
          exit 1
        fi
        
        if [[ $current_interface != "" ]]; then
          systemctl stop wg-quick-"''${current_interface}"
        fi

        check_if_exists $2
        if [[ "$?" -ne 1 ]]; then
          systemctl start wg-quick-"$2"
        else
          echo "interface $2 doesn't exist"
        fi
        ;;
      disconnect)
        if [[ $current_interface == "" ]]; then
          echo "vpn is not connected"
        else
          systemctl stop wg-quick-"''${current_interface}"
        fi
        ;;
      interfaces)
        get_servers
        ;;
      *)
        echo "unknown command $1"
        echo "$usage"
        ;;
    esac
  '';

  serverOpts = { ... }:
  {
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
      enable = mkEnableOption "vpn";
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
        default = [ "1.1.1.1" ];
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
      defaultGateway = {
        address = mkOption {
          type = types.str;
          description = "get this by running ip route show default";
        };
        interface = mkOption {
          type = types.str;
          description = "get this by running ip route show default";
        };
      };
    };
  };

  config = {
    systemd.services.NetworkManager-wait-online.enable = false;

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "vpn" vpnScript)
    ];

    networking = {
      useDHCP = false;
      dhcpcd.enable = false;
      networkmanager = {
        enable = true;
        dns = "none";
        wifi.macAddress = "random";
      };

      firewall.enable = true;

      nameservers = ["1.1.1.1"];

      wg-quick.interfaces = let
        mkIP = keyword: ip: "ip route ${keyword} ${ip} via ${cfg.vpn.defaultGateway.address}";

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
              allowedIPs = [ "0.0.0.0/0" "::/0" ];
              persistentKeepalive = 25; # remove
            }
          ];

          postUp = concatMapStringsSep "; " (mkIP "add") cfg.vpn.disabledIPs;
          postDown = concatMapStringsSep "; " (mkIP "del") cfg.vpn.disabledIPs;
        };
      in if cfg.vpn.enable then attrsets.mapAttrs' mkInterface cfg.vpn.servers else {};
    };
  };
}
