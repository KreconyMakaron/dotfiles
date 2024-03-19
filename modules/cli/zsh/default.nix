{config, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;

    shellAliases = import ./aliases.nix {inherit config;};
    # ToDo: configure oh-my-zsh

    # sets the title of foot to the last executed command used in hyprland/rules
    initExtra = ''
         setfoottitle () {
         	printf '\e]2;%s\e' $1
         }

      add-zsh-hook -Uz preexec setfoottitle
    '';
  };
}
