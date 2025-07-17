{...}: {
  programs = {
    ripgrep.enable = true; # better grep
    bat.enable = true; # better cat
    jq.enable = true; # json parser
    lazygit.enable = true; # i dont remember most git commands

    # better ls
    eza = {
      enable = true;
      icons = "auto";
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
}
