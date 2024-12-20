{...}: {
	imports = [./fonts.nix];
	environment.etc."greetd/environments".text = ''
    Hyprland
	'';

	programs.hyprland.enable = true;

	environment = {
		variables = {
			NIXOS_OZONE_WL = "1";
			__GL_GSYNC_ALLOWED = "0";
			__GL_VRR_ALLOWED = "0";
			_JAVA_AWT_WM_NONEREPARENTING = "1";
			DISABLE_QT5_COMPAT = "0";
			GDK_BACKEND = "wayland,x11";
			ANKI_WAYLAND = "1";
			DIRENV_LOG_FORMAT = "";
			WLR_DRM_NO_ATOMIC = "1";
			QT_AUTO_SCREEN_SCALE_FACTOR = "1";
			QT_QPA_PLATFORM = "wayland;xcb";
			DISABLE_QT_COMPAT = "0";
			QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
			MOZ_ENABLE_WAYLAND = "1";
			WLR_BACKEND = "vulkan";
			#WLR_RENDERER = "vulkan"; # https://github.com/hyprwm/Hyprland/issues/5996
			XDG_SESSION_TYPE = "wayland";
			SDL_VIDEODRIVER = "wayland";
			CLUTTER_BACKEND = "wayland";
		};
	};
}
