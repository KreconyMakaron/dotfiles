{pkgs, ...}: {
  home.packages = with pkgs; [
    clang
    nixd
    lazygit
  ];
  programs.neovim = {
    enable = true;
  };
}
