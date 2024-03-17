{config, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    shellAliases = import ./aliases.nix {inherit config;};
    # configure oh-my-zsh
  };
}
