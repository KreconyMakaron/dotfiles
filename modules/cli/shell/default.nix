{ pkgs, ... }: let
	inherit (pkgs.lib) getExe getExe';
in {
	imports = [ ./starship.nix ];

	programs.zsh = {
		enable = true;
		enableCompletion = true;

		dotDir = ".config/zsh";

		history = {
			size = 100000000;
			save = 100000000;
			ignoreAllDups = true;
			ignoreDups = true;
			path = "$HOME/.cache/.zsh_history";
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

		initExtra = let
			zsh-sudo = pkgs.fetchFromGitHub {
				owner = "hcgraf";
				repo = "zsh-sudo";
				rev = "0b29d30d8666b5272a6286da62b5036de2c83dee";
				hash = "sha256-I17u8qmYttsodD58PqtTxtVZauyYcNw1orFLPngo9bY=";
			} + "/sudo.plugin.zsh";
		in ''
			cpfile () {
				${getExe pkgs.bat} -pp $1 | ${getExe' pkgs.wl-clipboard "wl-copy"}
			}

			eval "$(${getExe pkgs.direnv} hook zsh)"

			source ${pkgs.zsh-defer}/share/zsh-defer/zsh-defer.plugin.zsh
			source ${./config.zsh}

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
