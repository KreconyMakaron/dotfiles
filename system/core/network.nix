{pkgs, ...}: {
	environment.systemPackages = with pkgs; [
		speedtest-cli
		usb-modeswitch
	];
	networking = {
		networkmanager = {
			enable = true;
		};
	};
}
