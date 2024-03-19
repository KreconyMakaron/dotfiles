{pkgs, ...}: {
	home.packages = with pkgs; [
		# https://gist.github.com/mxdevmanuel/a2229d427b39a9e40f2198979caa40c1
		(writeShellScriptBin "wofi-powermenu"
		''
			op=$( echo -e " Poweroff\n󰑓 Reboot\n Suspend\n Lock\n Logout" | wofi -i --dmenu | awk '{print tolower($2)}' )
			case $op in 
				poweroff)
								;&
				reboot)
								;&
				suspend)
								systemctl $op
								;;
				lock)
								#lock
								;;
				logout)
								hyprctl dispatch exit
								;;
			esac
		'')
	];
	programs.wofi = {
		enable = true
	;}
;}
