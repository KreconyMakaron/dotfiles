{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    histSize = 100000000;
    histFile = "$HOME/.cache/.zsh_history";

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

    shellInit = let
      zsh-sudo =
        pkgs.fetchFromGitHub {
          owner = "hcgraf";
          repo = "zsh-sudo";
          rev = "0b29d30d8666b5272a6286da62b5036de2c83dee";
          hash = "sha256-I17u8qmYttsodD58PqtTxtVZauyYcNw1orFLPngo9bY=";
        }
        + "/sudo.plugin.zsh";
    in ''
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

      zstyle ':completion:*' list-colors $${(s.:.)LS_COLORS}

      # vi mode
      bindkey -v
      export KEYTIMEOUT=1

      # https://nixos.wiki/wiki/Zsh#Zsh-autocomplete_not_working
      bindkey "${key [Up]}" up-line-or-search

      zsh-defer source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
      zsh-defer source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      zsh-defer source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      zsh-defer source ${pkgs.zsh-autopair}/share/zsh/zsh-autopair/autopair.zsh
      zsh-defer source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      zsh-defer source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh
      zsh-defer source ${zsh-sudo}
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$line_break$python$character";
      palette = "everforest";
      palettes = with config.lib.stylix.colors.withHashtag; {
        everforest = {
          color_bg1 = base01;
          color_bg3 = base03;
          color_fg0 = base07;
          color_red = base08;
          color_yellow = base0A;
          color_green = base0B;
          color_cyan = base0C;
          color_blue = base0D;
          color_purple = base0E;
          color_orange = base0F;
          color_bright-black = base04;
        };
      };
      directory = {
        style = "fg:color_blue";
      };
      character = {
        success_symbol = "[❯](fg:color_purple)";
        error_symbol = "[❯](fg:color_red)";
        vimcmd_symbol = "[❮](fg:color_green)";
      };
      git_branch = {
        format = "[$branch]($style)";
        style = "fg:color_bright-black";
      };
      git_status = {
        format = "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style) ";
        style = "fg:color_cyan";
        conflicted = "​";
        untracked = "​";
        modified = "​";
        staged = "​";
        renamed = "​";
        deleted = "​";
        stashed = "≡";
      };
      git_state = {
        format = "\([$state( $progress_current/$progress_total)]($style)\) ";
        style = "fg:color_bright-black";
      };
      cmd_duration = {
        format = "[$duration]($style) ";
        style = "fg:color_yellow";
      };
      python = {
        format = "[$virtualenv]($style) ";
        style = "fg:color_bright-black";
      };
    };
  };
}
