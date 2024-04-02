{pkgs, ...}: {
	programs.neovim = {
		enable = true;
		extraPackages = [
			pkgs.clang-tools
			pkgs.pyright
			pkgs.nixd
		];
	};
}
