{pkgs, ...}: {
  programs.neovim = {
    enable = false;
    extraPackages = with pkgs; [
      nixd
      go
      clang-tools
			gcc
			pyright
    ];
  };
}
