{pkgs, ...}: {
	programs.neovim = {
		enable = true;
		extraPackages = with pkgs; [
			clang-tools
			gcc
			pyright
			nixd
			nodePackages_latest.vim-language-server
			nodePackages_latest.bash-language-server
			nodePackages_latest.vscode-json-languageserver
			nodePackages_latest.typescript-language-server
		];
	};
}
