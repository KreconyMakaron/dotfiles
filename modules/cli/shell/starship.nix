{config, ...}: {
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
