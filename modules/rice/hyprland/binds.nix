{
	lib,
	pkgs,
	...
}: let
	mod = "SUPER";
	modshift = "SUPER SHIFT";
in {
	wayland.windowManager.hyprland.settings = {
		bind = [
			"${mod},RETURN,exec,${lib.getExe pkgs.foot}"
			"${mod},Q,killactive"

			"${mod},H,movefocus,l"
			"${mod},L,movefocus,r"
			"${mod},K,movefocus,u"
			"${mod},J,movefocus,d"

			"${mod},D,exec,${lib.getExe pkgs.ags} -t applauncher"
			"${mod},V,togglefloating,"
			"${mod},F,fullscreen,"
			"${mod},W,exec,${lib.getExe pkgs.firefox-devedition}"
			"${mod},BACKSPACE,exec,wofi-powermenu"
			"${mod},C,exec,${lib.getExe pkgs.ags} -t clipboard"
			"${modshift},L,exec,${lib.getExe pkgs.hyprlock}"

			",Print,exec,${lib.getExe pkgs.grimblast} --freeze copysave screen $XDG_PICTURES_DIR/$(date +ScreenShot-%F-%R:%S).png"
			"${mod},Print,exec,${lib.getExe pkgs.grimblast} --freeze copysave area $XDG_PICTURES_DIR/$(date +ScreenShot-%F-%R:%S).png"
			"${modshift},Print,exec,${lib.getExe pkgs.grimblast} --freeze copysave active $XDG_PICTURES_DIR/$(date +ScreenShot-%F-%R:%S).png"

			",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
		]
		++ (
			builtins.concatLists (builtins.genList (
					x: let
						ws = let
							c = (x + 1) / 10;
						in
							builtins.toString (x + 1 - (c * 10));
					in [
						"${mod}, ${ws}, workspace, ${toString (x + 1)}"
						"${modshift}, ${ws}, movetoworkspace, ${toString (x + 1)}"
					]
				)
				10)
		);

		bindm = [
			"${mod},mouse:272,movewindow"
			"${mod},mouse:273,resizewindow"
		];
		binde = [
			",XF86MonBrightnessUp,exec,${lib.getExe pkgs.brightnessctl} set +10%"
			",XF86MonBrightnessDown,exec,${lib.getExe pkgs.brightnessctl} set 10%-"
			",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
			",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
		];
	};
}
