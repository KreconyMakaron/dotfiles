{...}: {
	wayland.windowManager.hyprland.settings = {
		windowrulev2 = [
			"float,class:^(org.pulseaudio.pavucontrol)$"
			"center,class:^(org.pulseaudio.pavucontrol)$"
			"size 50% 50%,class:^(org.pulseaudio.pavucontrol)$"
			"dimaround,class:^(org.pulseaudio.pavucontrol)$"

			"opacity 1.0 0.7,class:^(foot)$"

			"float,class:^(foot)$,title:^(nmtui)$"
			"center,class:^(foot)$,title:^(nmtui)$"
			"dimaround,class:^(foot)$,title:^(nmtui)$"

			"center,class:^(firefox)$,floating:1"

			"size 70% 70%,title:^(.*)$,class:^(.*)$,floating:1"
		];
	};
}
