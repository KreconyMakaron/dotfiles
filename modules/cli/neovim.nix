{pkgs, ...}: {
	programs.neovim = {
		enable = true;
		extraPackages = with pkgs; [
			clang-tools
			pyright
			nixd
			nodePackages.vim-language-server
			nodePackages.bash-language-server
			nodePackages.vscode-json-languageserver-bin
		];
	};
}
