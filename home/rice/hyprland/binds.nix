{ 
	config, 
	lib,
	...
}: let
	mod = "SUPER";
in {
	wayland.windowManager.hyprland.settings = {
		bind = [
			"${mod},RETURN,exec,kitty"
			"${mod},P,exec,kitty"
			"${mod},Q,killactive"


			"${mod},H,movefocus,l"
			"${mod},L,movefocus,r"
			"${mod},K,movefocus,u"
			"${mod},J,movefocus,d"

			"${mod},D,exec,rofi -show drun"
			"${mod},V,togglefloating,"
			"${mod},F,fullscreen,"
		];
		bindm = [
			"${mod},mouse:272,movewindow"
			"${mod},mouse:273,resizewindow"
		];
		binde = [
			",XF86MonBrightnessUp,exec,brightnessctl set +10%"
			",XF86MonBrightnessDown,exec,brightnessctl set 10%-"
		];
	};
}
