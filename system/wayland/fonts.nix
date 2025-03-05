{pkgs, ...}: {
	fonts = {
		packages = with pkgs; [
			jetbrains-mono
			noto-fonts
			noto-fonts-cjk-sans
			noto-fonts-emoji
			hermit
			dejavu_fonts
		] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
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
