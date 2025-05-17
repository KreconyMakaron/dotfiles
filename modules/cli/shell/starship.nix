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
		# settings = {
		# 	# https://starship.rs/presets/gruvbox-rainbow but i added stylix support :3
		# 	format = "[](color_orange)$username[](bg:color_yellow fg:color_orange)$directory[](bg:color_purple fg:color_yellow)$nix_shell[](fg:color_purple bg:color_aqua)$git_branch$git_status[](fg:color_aqua bg:color_blue)$c$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:color_blue bg:color_bg3)$docker_context$conda[](fg:color_bg3 bg:color_bg1)$time[ ](fg:color_bg1)$line_break$character";
		# 	palette = "gruvbox_dark";
		# 	palettes = with config.lib.stylix.colors.withHashtag; {
		# 		gruvbox_dark = {
		# 			color_bg1 = base01;
		# 			color_bg3 = base03;
		# 			color_fg0 = base07;
		# 			color_red = base08;
		# 			color_yellow = base0A;
		# 			color_green = base0B;
		# 			color_aqua = base0C;
		# 			color_blue = base0D;
		# 			color_purple = base0E;
		# 			color_orange = base0F;
		# 		};
		# 	};
		# 	nix_shell = {
		# 		format = "[ nix-shell ](bg:color_purple fg:color_fg0)";
		# 	};
		# 	username = {
		# 		show_always = true;
		# 		style_user = "bg:color_orange fg:color_fg0";
		# 		style_root = "bg:color_orange fg:color_fg0";
		# 		format = "[ $user ]($style)";
		# 	};
		# 	directory = {
		# 		style = "fg:color_fg0 bg:color_yellow";
		# 		format = "[ $path ]($style)";
		# 		truncation_length = 3;
		# 		truncation_symbol = "…/";
		# 		substitutions = {
		# 			Documents = "󰈙 ";
		# 			Downloads = " ";
		# 			Music = "󰝚 ";
		# 			Pictures = " ";
		# 			Developer = "󰲋 ";
		# 		};
		# 	};
		# 	git_branch = {
		# 		symbol = "";
		# 		style = "bg:color_aqua";
		# 		format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
		# 	};
		# 	git_status = {
		# 		style = "bg:color_aqua";
		# 		format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
		# 	};
		# 	nodejs = {
		# 		symbol = "";
		# 		style = "bg:color_blue";
		# 		format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		# 	};
		# 	c = {
		# 		symbol = " ";
		# 		style = "bg:color_blue";
		# 		format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		# 	};
		# 	rust = {
		# 		symbol = "";
		# 		style = "bg:color_blue";
		# 		format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		# 	};
		# 	golang = {
		# 		symbol = "";
		# 		style = "bg:color_blue";
		# 		format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		# 	};
		# 	php = {
		# 		symbol = "";
		# 		style = "bg:color_blue";
		# 		format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		# 	};
		# 	java = {
		# 		symbol = " ";
		# 		style = "bg:color_blue";
		# 		format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		# 	};
		# 	kotlin = {
		# 		symbol = "";
		# 		style = "bg:color_blue";
		# 		format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		# 	};
		# 	haskell = {
		# 		symbol = "";
		# 		style = "bg:color_blue";
		# 		format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		# 	};
		# 	python = {
		# 		symbol = "";
		# 		style = "bg:color_blue";
		# 		format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
		# 	};
		# 	docker_context = {
		# 		symbol = "";
		# 		style = "bg:color_bg3";
		# 		format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
		# 	};
		# 	conda = {
		# 		style = "bg:color_bg3";
		# 		format = "[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)";
		# 	};
		# 	time = {
		# 		disabled = false;
		# 		time_format = "%R";
		# 		style = "bg:color_bg1";
		# 		format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
		# 	};
		# 	line_break = {
		# 		disabled = false;
		# 	};
		# 	character = {
		# 		disabled = false;
		# 		success_symbol = "[](bold fg:color_green)";
		# 		error_symbol = "[](bold fg:color_red)";
		# 		vimcmd_symbol = "[](bold fg:color_green)";
		# 		vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
		# 		vimcmd_replace_symbol = "[](bold fg:color_purple)";
		# 		vimcmd_visual_symbol = "[](bold fg:color_yellow)";
		# 	};
		# };
	};
}
