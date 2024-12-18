{pkgs, ...}: {
	fonts = {
		packages = with pkgs; [
			jetbrains-mono
			noto-fonts
			noto-fonts-cjk-sans
			noto-fonts-emoji
			nerdfonts
			hermit
			dejavu_fonts
		];
		fontconfig = {
			defaultFonts = {
				monospace = [ "JetBrainsMono" ];
				sansSerif = [ "Dejavu Sans" ];
				serif = [ "Dejavu Serif" ];
				emoji = [ "Noto Color Emoji" ];
			};
		};
	};
}
