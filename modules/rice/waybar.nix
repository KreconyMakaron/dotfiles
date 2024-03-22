{
	theme,
	lib,
	pkgs,
	...
}: 
with lib; let 
	vertical-margin = "5px";
	right-margin = "10px";
	left-margin = "10px";
	nix-workspace-margin = "7px";
	border-radius = "10px";
	waybar-bg = "rgba(42, 42, 42, 0.8)";
in
{
	programs.waybar = with theme.colors; {
		enable = true;
		systemd = {
			enable = true;
			target = "hyprland-session.target";
		};
		style = ''
			window#waybar {
				background-color: ${waybar-bg};
				color: #${waybar-text} ;
				font-size: 12px;
			}
			#battery.warning {
				color: #${peach};
			}
			#battery.critical {
				color: #${red}
			}
			#workspaces {
				font-size: 12px;
				background-color: #${waybar-modules};
				margin: ${vertical-margin} 0;
				border-radius: ${border-radius};
				padding: 0 5px;
			}
			#workspaces button {
				background-color: #${waybar-modules};
				box-shadow: inset 0 -3px transparent;
				color: #${waybar-text};
			}
			#workspaces button:hover {
				/*fix extremely ugly hover effect https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect*/
				box-shadow: inherit;
				background: #${waybar-selected-workspace} ;
				padding: 0px 9px;
			}
			#workspaces button.active {
				background-color: #${waybar-selected-workspace};
			}
			#workspaces button.urgent {
				background-color: #${red};
			}
			#workspaces.windows {
				background-color: transparent;
				margin: ${vertical-margin} 0;
			}
			#workspaces.windows button {
				background-color: transparent;
				color: #${waybar-modules};
			}
			#clock {
				border-radius: ${border-radius};
				margin: ${vertical-margin} 0;
				padding: 0 7px;
				background-color: #${waybar-modules};
			}
			#battery, #wireplumber, #network {
				padding: 0 10px;
				background-color: #${waybar-modules};
				margin: ${vertical-margin} 0;
			}
			#network {
				padding: 0 15px;
			}
			#battery {
				margin-right: ${right-margin};
				border-radius: 0 ${border-radius} ${border-radius} 0;
			}
			#wireplumber {
				border-radius: ${border-radius} 0 0 ${border-radius};
			}
			#custom-powermenu {
				margin: ${vertical-margin} ${nix-workspace-margin} ${vertical-margin} ${left-margin};
				border-radius: ${border-radius};
				background-color: #${waybar-modules};
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
				output = [
					"eDP-1"
				];
				modules-left = ["custom/powermenu" "hyprland/workspaces"];
				modules-center = ["clock"];
				modules-right = ["hyprland/workspaces#windows" "wireplumber" "network" "battery"];
				"custom/powermenu" = {
					format = " ";
					on-click = "wofi-powermenu";
					tooltip = false;				
				};
				"hyprland/workspaces" = {
					on-click = "activate";
					format = "{icon}";
					active-only = false;
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
				"hyprland/workspaces#windows" = {
					format = "{windows}";
					active-only = true;
					window-rewrite-default = "";
					window-rewrite = {
						"foot" = "";
						"class<foot> title<.*nvim.*>" = "";
						"class<foot> title<.*lazygit.*>" = "󰊢";
						"discord" = "󰙯";

						"pavucontrol" = "";

						"class<firefox>" = "󰈹";
						"class<firefox> title<.*youtube.*>" = "";
						"class<firefox> title<.*reddit.*>" = "󰑍";
						"class<firefox> title<.*discord.*>" = "󰙯";
						"class<firefox> title<.*soundcloud.*>" = "󰓀";
						"class<firefox> title<.*github.*>" = "󰊢";
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
					calendar = {
						mode = "year";
						mode-mon-col = 3;
						weeks-pos = "right";
						on-click-right = "mode";
						format = {
							months = "<span color='#${text}'><b>{}</b></span>";
							weeks = "<span color='#${text}'><b>W{}</b></span>";
							weekdays = "<span color='#${text}'><b>{}</b></span>";
							days = "<span color='#${text}'>{}</span>";
							today = "<span color='#${accent}'><b><u>{}</u></b></span>";
						};
					};
					actions = {
						on-click-right = "mode";
						on-click-forward = "tz_up";
						on-click-backward = "tz_down";
						on-scroll-up = "shift_up";
						on-scroll-down = "shift_down";
					};
				};
			};
		};
	};
}
