{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    speedtest-cli
    usb-modeswitch
  ];

  systemd.services.NetworkManager-wait-online.enable = false;

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
      server-list = [
        {
          name = "poland";
          autostart = true;
          pubKey = "wpfRQRhJirL++QclFH6SDhc+TuJJB4UxbCABy7A1tS4=";
          endpoint = "79.127.186.193:51820";
        }
        {
          name = "czechia-p2p";
          pubKey = "sDVKmYDevvGvpKNei9f2SDbx5FMFi6FqBmuRYG/EFg8=";
          endpoint = "146.70.129.18:51820";
        }
      ];

      interfaces = builtins.listToAttrs (map (
          iface: {
            name = iface.name;
            value = {
              autostart = iface.autostart or false;
              dns = ["10.2.0.1"];
              privateKeyFile = "/root/protonvpn-keys/${iface.name}";
              address = ["10.2.0.2/32"];
              listenPort = 51820;
              mtu = 1280;

              peers = [
                {
                  publicKey = iface.pubKey;
                  allowedIPs = ["0.0.0.0/0" "::/0"];
                  endpoint = iface.endpoint;
                  persistentKeepalive = 25;
                }
              ];

              # exclude nixos.wiki as they get mad at protonvpn
              postUp = "ip route add 172.67.75.217 via 192.168.0.1";
              postDown = "ip route del 172.67.75.217 via 192.168.0.1";
            };
          }
        )
        server-list);
    in
      interfaces;
  };
}
