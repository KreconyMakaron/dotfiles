{
lib, 
pkgs, 
inputs,
...
}: {
	wayland.windowManager.hyprland = {
		enable = true;
		package = inputs.hyprland.packages.${pkgs.system}.hyprland;
		xwayland.enable = true;
		systemd = {
			variables = ["--all"];
			extraCommands = [
				"systemctl --user stop graphical-session.target"
				"systemctl --user start hyprland-session.target"
			];
		};
		settings = {
			exec-once = [
				"${lib.getExe pkgs.wl-clip-persist} --clipboard both"
				"${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch cliphist store"
			];

			general = {
				gaps_in = 0;
				gaps_out = 0;
				resize_on_border = 1;
				border_size = 0;
			};
			monitor = [
				"eDP-1,1920x1080@60,0x0,1.25"
				",preferred,auto,1"
			];
			debug = {
				disable_logs = false;
			};
			xwayland.force_zero_scaling = true;
			input = {
				kb_layout = "pl";
				follow_mouse = 1;
				repeat_delay = 300;
				touchpad = {
					disable_while_typing = false;
					scroll_factor = 0.5;
					natural_scroll = true;
				};
			};
			decoration.blur = {
				enabled = true;
				size = 4;
				passes = 2;
				new_optimizations = true;
				ignore_opacity = true;
			};
			gestures = {
				workspace_swipe = true;
				workspace_swipe_forever = true;
			};
			misc = {
				disable_hyprland_logo = true;
				disable_splash_rendering = true;
				force_default_wallpaper = 0;
				animate_manual_resizes = true;

				disable_autoreload = true;

				enable_swallow = true;
				swallow_regex = "^(foot)";
				swallow_exception_regex = "^(pavucontrol)$";
			};
		};
	};
}
