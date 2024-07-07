{pkgs, ...}: {
	home.file.".local/share/icons/HyprBibataModernClassicSVG" = {
		source = pkgs.fetchzip {
			url = "https://cdn.discordapp.com/attachments/1216066899729977435/1216076659149504643/HyprBibataModernClassicSVG.tar.gz?ex=66084d25&is=65f5d825&hm=6430e39b34b09b70884de44d6b961904b33c4c8e1d6b0c657eda5cb9ef6ca3a7&";
			hash = "sha256-8BkQuBVrV/QAy7whD3zQPFwJKXJ7YgLdDcqFDg/zJQA=";
		};
	};

	wayland.windowManager.hyprland.settings.env = [
		"HYPRCURSOR_THEME,HyprBibataModernClassicSVG"
		"HYPRCURSOR_SIZE,24"
	];
}
