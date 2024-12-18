{pkgs, ...}: let
	inherit (pkgs.lib) getExe getExe';
in {
	services.hypridle = {
		enable = true;
		settings = {
			general = {
				lock_cmd = "pidof ${getExe pkgs.hyprlock} || ${getExe pkgs.hyprlock}";
				before_sleep_cmd = "loginctl lock-session";
				after_sleep_cmd = "${getExe' pkgs.hyprland "hyprctl"} dispatch dpms on";
			};

			listener = [
				# lock after 5 minutes
				{
					timeout = 300;
					on-timeout = "loginctl lock-session";
				}
				# hibernate after 15 minutes
				{
					timeout = 900;
					on-timeout = "systemctl hybrid-sleep";
				}
			];
		};
	};
}
