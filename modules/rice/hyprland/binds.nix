{
	lib,
	pkgs,
	...
}: let
	mod = "SUPER";
	modshift = "SUPER SHIFT";
in {
	wayland.windowManager.hyprland.settings = {
		bind =
			[
				"${mod},RETURN,exec,${lib.getExe pkgs.foot}"
				"${mod},Q,killactive"

				"${mod},H,movefocus,l"
				"${mod},L,movefocus,r"
				"${mod},K,movefocus,u"
				"${mod},J,movefocus,d"

				"${mod},D,exec,${lib.getExe pkgs.wofi} --show drun"
				"${mod},V,togglefloating,"
				"${mod},F,fullscreen,"
				"${mod},W,exec,${lib.getExe pkgs.firefox-devedition-unwrapped}"
				"${mod},BACKSPACE,exec,wofi-powermenu"
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
		];
	};
}
