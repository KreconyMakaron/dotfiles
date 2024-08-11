{inputs, theme, pkgs, ...}: {
	imports = [ inputs.stylix.homeManagerModules.stylix ];

	stylix = {
		image = theme.wallpaper;
		base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
		polarity = "dark";
		
		opacity = {
			terminal = 0.75;
		};

		cursor = {
			size = 24;
			name = "Bibata-Modern-Classic";
			package = pkgs.runCommand "moveUp" {} ''
				mkdir -p $out/share/icons
				ln -s ${pkgs.fetchzip {
					url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz";
					hash = "sha256-jpEuovyLr9HBDsShJo1efRxd21Fxi7HIjXtPJmLQaCU=";
			}} $out/share/icons/Bibata-Modern-Classic
			'';
		};

		targets = {
			vim.enable = false;
			vesktop.enable = true;
		};
	};
}
