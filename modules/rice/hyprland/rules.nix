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

			"float,class:^(foot)$,title:(nmtui)"
			"center,class:^(foot)$,title:(nmtui)"
			"dimaround,class:^(foot)$,title:(nmtui)"

			"center,class:^(firefox)$,floating:1"

			"size 70% 70%,title:^(.*)$,class:^(.*)$,floating:1"
		];
	};
}
