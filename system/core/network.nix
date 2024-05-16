{pkgs, ...}: {
	environment.systemPackages = with pkgs; [
		speedtest-cli
		usb-modeswitch
	];
	networking = {
		networkmanager = {
			enable = true;

			wifi = {
				powersave = true;
				macAddress = "random";
			};
		};

		firewall = {
			enable = true;
			allowPing = true;
		};
	};
}
