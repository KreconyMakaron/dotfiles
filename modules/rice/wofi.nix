{theme, pkgs, ...}: {
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
								hyprlock
								;;
				logout)
								hyprctl dispatch exit
								;;
			esac
		'')
	];
	programs.wofi = {
		enable = true;
		settings = {
			sort_order = "alphabetical";
			allow_images = true;
			insensitive = true;
			height = "40%";
			width = "25%";
			x = "-30px";
			y = "-30px";
			prompt = "Search...";
			location = "bottom_right";
			image_size = "20px";
		};
		style = with theme.colors; ''
			#inner-box {
				padding: 10px;
			}

			#outer-box {
				border: 4px solid #${base4};
			}

			#entry {
				background: #${base0};
				padding-left: 2px;
			}

			#text {
				font-size: 12px;
				color: #${base4};
			}

			#img {
				padding-right: 7px;
			}

			#entry:selected {
				border: 2px solid #${base4};
				padding-left: 0px;
			}
		'';
	};
}
