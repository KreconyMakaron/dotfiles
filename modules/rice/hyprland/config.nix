{theme, ...}: {
	wayland.windowManager.hyprland = with theme.colors; {
		settings = {
			general = {
				gaps_in = 2;
				gaps_out = 5;
				border_size = 2;
				resize_on_border = 1;

				"col.active_border" = "rgb(${accent})";
				"col.inactive_border" = "rgb(${base})";
			};
			monitor = [
				"eDP-1,1920x1080@60,0x0,1.25"
			];
			xwayland.force_zero_scaling = true;
			input = {
				kb_layout = "pl";
				follow_mouse = 1;
				repeat_delay = 300;
				touchpad.scroll_factor = 0.8;
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
