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
			"size 50% 50%,class:^(foot),title:(nmtui)$"
			"dimaround,class:^(foot),title:(nmtui)$"

			"float,class:^(firefox)$,title:(Save As)"
			"center,class:^(firefox)$,title:(Save As)"
			"dimaround,class:^(firefox),title:(Save As)$"
			"size 70% 70%,class:^(firefox),title:(Save As)$"

			"float,class:^(firefox)$,title:(File Upload)"
			"center,class:^(firefox)$,title:(File Upload)"
			"dimaround,class:^(firefox),title:(File Upload)$"
			"size 70% 70%,class:^(firefox),title:(File Upload)$"
		];
	};
}
