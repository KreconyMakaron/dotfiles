{
  pkgs,
  importWithStuff,
  ...
}: {
  imports = builtins.map importWithStuff [
    ./zsh.nix
    ./starship.nix
  ];

  environment.systemPackages = with pkgs; [
    ripgrep
    bat
    eza
    jq
    btop
    tldr
    microfetch
    fzf
    unzip
    killall
    qrcp
    libqalculate
    gcc
  ];

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };
}
