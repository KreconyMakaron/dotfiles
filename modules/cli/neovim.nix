{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      nixd
      go
      clang-tools
			gcc
			pyright
    ];
  };
}
