{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_state$git_status$nix_shell$cmd_duration$line_break$python$character";
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
        format = "\\([$state( $progress_current/$progress_total)]($style)\\) ";
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
