{
	lib, 
	pkgs, 
	...
}: {
	programs.zsh = {
		enable = true;
		enableCompletion = true;
		autosuggestion.enable = true;

		shellAliases = {
			l = "eza -la --color=always";
			ll = "eza -la --color=always";
			ls = "eza --git --group-directories-first -s extension --color=always";
			la = "eza -lah --tree --group-directories-first --color=always";
			lt = "eza --icons --tree --group-directories-first --color=always";
			cat = "bat";
			kys = "shutdown now";
			".." = "cd ..";
			"..." = "cd ../..";
			"...." = "cd ../../..";
			"....." = "cd ../../../..";
		};

		# sets the title of foot to the last executed command used in hyprland/rules
		initExtra = ''
			setfoottitle () {
				printf '\e]2;%s\e\' $1
			}

			add-zsh-hook -Uz preexec setfoottitle

			nix-search () {
				${lib.getExe' pkgs.xdg-utils "xdg-open"} "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=$1"
			}

			cpfile () {
				${lib.getExe pkgs.bat} -pp $1 | wl-copy
			}
		'';
	};
}
