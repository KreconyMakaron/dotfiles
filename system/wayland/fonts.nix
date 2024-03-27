{pkgs, ...}: {
	fonts = {
		packages = with pkgs; [
			jetbrains-mono
			noto-fonts
			noto-fonts-cjk
			noto-fonts-emoji
			nerdfonts
			hermit
		];

		fontconfig = {
			defaultFonts = {
				monospace = [
					"JetBrainsMono"
				];
				sansSerif = [
				];
				serif = [
					"Noto Serif"
				];
				emoji = [
					"Noto Color Emoji"
				];
			};
		};
	};
}
