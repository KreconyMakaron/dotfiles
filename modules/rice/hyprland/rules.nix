{...}: {
	wayland.windowManager.hyprland.settings = {
		windowrule = [
			"float,^(pavucontrol)$"
			"center,^(pavucontrol)$"
			"size 50% 50%,^(pavucontrol)$"
			"dimaround,^(pavucontrol)$"
		];
		windowrulev2 = [
			"opacity 1.0 0.7,class:^(foot)$"

			# makes nvim windows opaque no matter if they are focused or not
			"opaque,class:^(foot)$,title:(nvim)"

			"float,class:^(foot)$,title:(nmtui)"
			"center,class:^(foot)$,title:(nmtui)"
			"dimaround,class:^(foot)$,title:(nmtui)"

			"center,class:^(firefox)$,floating:1"

			"size 70% 70%,title:^(.*)$,class:^(.*)$,floating:1"
		];
	};
}
