{theme, ...}: {
	programs.hyprlock = with theme.colors; {
		enable = true;

		general = {
			disable_loading_bar = true;
			hide_cursor = true;
		};

		backgrounds = [
			{
				monitor = "";
				path = "${theme.wallpaper}";
				blur_passes = 3;
				blur_size = 4;
				brightness = 0.6;
			}
		];

		input-fields = [
			{
				size = {
					width = 250;
					height = 50;
				};

				outer_color = "rgb(${hyprlock-dark})";
				inner_color = "rgb(${hyprlock-light})";
				font_color = "rgb(${hyprlock-dark})";

				check_color = "rgb(${hyprlock-dark})";
				fail_color = "rgb(${hyprlock-fail})";

				placeholder_text = ''<span font_family="${theme.hyprlock-font}" foreground="##${hyprlock-dark}">Enter Password...</span>'';
				fail_text = "<b>Failed :(</b>";

				fade_on_empty = false;
				position.y = -100;
			}
		];

		labels = [
			{	
				monitor = "";
				text = "Hejka $USER :3";
				color = "rgb(${hyprlock-light})";
				font_size = 20;
				font_family = theme.hyprlock-font;

				position.y = -30;
			}
			{	
				monitor = "";
				text = "$TIME";
				color = "rgb(${hyprlock-light})";
				font_size = 120;
				font_family = theme.hyprlock-font;

				position.y = 250;
			}
		];
	};
}
