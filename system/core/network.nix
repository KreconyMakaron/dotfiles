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

		nameservers = [ "1.1.1.1" ];

		wg-quick.interfaces = let 
			server-list = [
				{
					name = "poland";
					autostart = true;
					pubKey = "HKjdcdOwD434Dvj7wzN+j/TpchEVcwLm4mq0fuj1tT4=";
					endpoint = "146.70.161.162:51820";
				}
				{
					name = "czechia-p2p";
					pubKey = "sDVKmYDevvGvpKNei9f2SDbx5FMFi6FqBmuRYG/EFg8=";
					endpoint = "146.70.129.18:51820";
				}
			];

			interfaces = builtins.listToAttrs (map (iface: {
				name = iface.name;
				value = {
					autostart = iface.autostart or false;
					dns = [ "10.2.0.1" ];
					privateKeyFile = "/root/protonvpn-keys/${iface.name}";
					address = [ "10.2.0.2/32" ];
					listenPort = 51820;
					mtu = 1280;

					peers = [
						{ 
							publicKey = iface.pubKey;
							allowedIPs = [ "0.0.0.0/0" "::/0"];
							endpoint = iface.endpoint;
							persistentKeepalive = 25;
						}
					];
				};
			}
		) server-list);
		in interfaces;
	};
}
