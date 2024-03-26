{
	theme,
	lib,
	pkgs,
	...
}: 
with lib; let 
	top-margin = "4px";
	bottom-margin = "0";
	right-margin = "6px";
	left-margin = "6px";

	power-margin = "5px";
	volume-margin = "5px";

	font-size = "12px";
	border-radius = "10px";
	border-width = "3px";
in {
	programs.waybar = with theme.colors; {
		enable = true;
		systemd = {
			enable = true;
			target = "hyprland-session.target";
		};
		style = ''
			window#waybar {
				background-color: transparent;
				color: #${waybar-text};
				font-size: ${font-size};
			}

			#custom-powermenu, #workspaces, #clock, #battery, #wireplumber, #network {
				border: ${border-width} solid #${base4};
				background-color: #${waybar-modules};
				border-radius: ${border-radius};
				margin: ${top-margin} 0 ${bottom-margin} 0;
			}
			#workspaces {
				font-size: ${font-size};
				margin-left: ${left-margin};
				padding: 0 5px;
			}

			#workspaces button {
				box-shadow: inset 0 -3px transparent;
				color: #${waybar-text};
			}

			#workspaces button:hover {
				box-shadow: inherit;
				background: #${waybar-selected-workspace};
				padding: 0px 9px;
			}

			#workspaces button.active { background-color: #${waybar-selected-workspace}; }
			#workspaces button.urgent { background-color: #${red}; }

			#clock { padding: 0 7px; }
			#battery, #wireplumber, #network { padding: 0 10px; }

			#wireplumber {
				margin-left: ${volume-margin};
				border-radius: ${border-radius} 0 0 ${border-radius};
				border-width: ${border-width} 0 ${border-width} ${border-width};
			}

			#network {
				padding: 0 10px;
				border-width: ${border-width} 0;
				border-radius: 0;
			}

			#battery {
				border-radius: 0 ${border-radius} ${border-radius} 0;
				border-width: ${border-width} ${border-width} ${border-width} 0;
			}

			#custom-powermenu {
				margin-right: ${right-margin};
				margin-left: ${power-margin};
				padding: 0 17px;
				background-image: url("${theme.nix-snowflake}");
				background-position: center;
				background-repeat: no-repeat;
				background-size: 80%;
			}
		'';
		settings = {
			mainBar = {
				layer = "top";
				position = "top";
				height = 20;
				output = [ "eDP-1" ];
				modules-left = ["hyprland/workspaces"];
				modules-center = [];
				modules-right = ["clock" "wireplumber" "network" "battery" "custom/powermenu"];
				"custom/powermenu" = {
					format = " ";
					on-click = "wofi-powermenu";
					tooltip = false;				
				};
				"hyprland/workspaces" = {
					on-click = "activate";
					format = "{icon}";
					active-only = false;
					all-outputs = true;
					format-icons = {
						"1" = "Ⅰ";
						"2" = "Ⅱ";
						"3" = "Ⅲ";
						"4" = "Ⅳ";
						"5" = "Ⅴ";
						"6" = "Ⅵ";
						"7" = "Ⅶ";
						"8" = "Ⅷ";
						"9" = "Ⅸ";
						"10" = "Ⅹ";
					};
				};
				battery = {
					states = {
						warning = 25;
						critical = 10;
					};
					interval = 5;
					format = "{icon} {capacity}%";
					format-charging = "{icon} {capacity}%";
					tooltip-format = "{timeTo}";
					format-icons = ["󰂃" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
				};
				network = {
					format-wifi = "󰖩  {signalStrength}%";
					format-ethernet = "󰈀  {signalStrength}%";
					format-disconnected = "󰖪  {signalStrength}%";
					on-click = "foot --title nmtui nmtui";
					tooltip-format = "{ipaddr} @ {essid}";
				};
				wireplumber = {
					format = "{icon} {volume}%";
					format-muted = " 󰝟 ";
					on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
					on-click-right = "${lib.getExe pkgs.killall} pavucontrol || ${lib.getExe pkgs.pavucontrol}";
					scroll-step = 5;
					format-icons = ["󰕿" "󰖀" "󰕾"];
				};
				clock = {
					format = "{:%H:%M}  ";
					format-alt = "{:%A, %d.%m.%Y}  ";
					tooltip-format = "<tt><small>{calendar}</small></tt>";
					actions.on-click-right = "mode";
					calendar = {
						mode = "month";
						mode-mon-col = 3;
						weeks-pos = "right";
						on-click-right = "mode";
						format = {
							months = "<span color='#${text}'><b>{}</b></span>";
							weeks = "<span color='#${text}'><b>W{}</b></span>";
							weekdays = "<span color='#${text}'><b>{}</b></span>";
							days = "<span color='#${text}'>{}</span>";
							today = "<span color='#${text}'><b><u>{}</u></b></span>";
						};
					};
				};
			};
		};
	};
}
