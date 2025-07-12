{pkgs, ...}: {
  programs = {
    ripgrep.enable = true; # better grep
    bat.enable = true; # better cat
    jq.enable = true; # json parser
    lazygit.enable = true; # i dont remember most git commands

    # better ls
    eza = {
      enable = true;
      icons = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # cool stats
    btop = {
      enable = true;
      settings.update_ms = 1000;
    };
  };

  home.packages = with pkgs; [
    mangal # real cool manga reader
    libqalculate # best calculator

    tldr # manpages but short
    fzf # fuzzy searching
    unzip # well unzips stuff
    killall # useful when i fuck up
    # hyperfine			# program benchmark tool
    qrcp # cool file sharing through local network
  ];
}
