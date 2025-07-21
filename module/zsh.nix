{
  pkgs,
  lib,
  user,
  ...
}:
with lib; let
  histFile = "$HOME/.cache/.zsh_history";
  histSize = 100000000;
in {
  programs.zsh.enable = true;
  home-manager.users.${user}.programs.zsh = {
    enable = true;
    enableCompletion = true;

    dotDir = ".config/zsh";

    history = {
      size = histSize;
      save = histSize;
      ignoreAllDups = true;
      ignoreDups = true;
      path = histFile;
    };

    shellAliases = {
      l = "${getExe pkgs.eza} -la --color=always";
      ll = "${getExe pkgs.eza} -la --color=always";
      ls = "${getExe pkgs.eza} --git --group-directories-first -s extension --color=always";
      la = "${getExe pkgs.eza} -lah --tree --group-directories-first --color=always";
      lt = "${getExe pkgs.eza} --icons --tree --group-directories-first --color=always";
      cat = "${getExe pkgs.bat} -pp";
      kys = "shutdown now";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "....." = "cd ../../../..";
    };
    initContent = let
      zsh-sudo =
        pkgs.fetchFromGitHub {
          owner = "hcgraf";
          repo = "zsh-sudo";
          rev = "0b29d30d8666b5272a6286da62b5036de2c83dee";
          hash = "sha256-I17u8qmYttsodD58PqtTxtVZauyYcNw1orFLPngo9bY=";
        }
        + "/sudo.plugin.zsh";
    in
      /*
      bash
      */
      ''
        cpfile () {
          ${getExe pkgs.bat} -pp $1 | ${getExe' pkgs.wl-clipboard "wl-copy"}
        }

        eval "$(${getExe pkgs.direnv} hook zsh)"

        source ${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh
        export ZSH_AUTOSUGGEST_STRATEGY=history
        eval "$(fzf --zsh)"

        # sets the title of foot to the last executed command, used in hyprland/rules
        setfoottitle () {
          printf '\e]2;%s\e\' $1
        }

        add-zsh-hook -Uz preexec setfoottitle

        zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}

        # vi mode
        bindkey -v
        export KEYTIMEOUT=1

        # https://nixos.wiki/wiki/Zsh#Zsh-autocomplete_not_working
        bindkey "''${key[Up]}" up-line-or-search

        zsh-defer source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
        zsh-defer source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        zsh-defer source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
        zsh-defer source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
        zsh-defer source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        zsh-defer source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
        zsh-defer source ${zsh-sudo}
      '';
  };
}
