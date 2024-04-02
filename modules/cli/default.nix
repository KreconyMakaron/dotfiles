{
	pkgs, 
	lib, 
	...
}: {
	imports = [
		./zsh.nix
		./tools.nix
		./git.nix
		./neovim.nix
		./btop.nix
	];
	home.packages = with pkgs; [
		ripgrep
		hyperfine
		jq
		unzip
		qrcp
		neofetch
		killall
		lazygit
		(writeShellScriptBin "rebuild"
		''
			spinner() {
				pid=$!

				spin='▁▂▃▄▅▆▇█'
				i=0
				while kill -0 $pid 2>/dev/null
				do
					i=$(( (i+1) %8 ))
					printf "\r$1 ''${spin:$i:1}  "
					sleep .1
				done
			}

			success() {
				printf "\r$1 \e[32m✓\e[0m"
			}

			fail() {
				printf "\r$1 \e[31m✗\e[0m"
			}

			deadnixoutput="/tmp/deadnix-output"
			nixosrebuild="/tmp/nixos-rebuild.log"

			host=$1

			pushd ~/.dotfiles &>/dev/null

			${lib.getExe pkgs.deadnix} &>$deadnixoutput &
			spinner "Looking for unused code..."
			deadout=$(${lib.getExe pkgs.bat} --style=plain $deadnixoutput) 

			if [[ "$deadout" == "" ]]; then
				success "Looking for unused code..."
			else
				fail "Looking for unused code..."
				printf "\n$deadout\n"
				read -p "Refactor? [Y/n] " decision
				if [[ "$decision" = "" || "$decison" = "y" || "$decision" = "Y" ]]; then 
					${lib.getExe pkgs.deadnix} -e &>/dev/null
				fi
			fi

			${lib.getExe pkgs.git} add .

			echo ""
			sudo nixos-rebuild switch --flake .$1 &>$nixosrebuild &

			spinner "Rebuilding system..."

			if wait $pid; then
				success "Rebuilding system..."
			else
				printf "\r                                                                                 "
				fail "Rebuilding system..."
				printf "\n\n\e[31mREBUILD SWITCH LOG:\e[0m\n\n$(cat $nixosrebuild)"
				exit
			fi

			echo ""

			${lib.getExe pkgs.git} commit -am "Generation $(nixos-rebuild list-generations 2>/dev/null | ${lib.getExe ripgrep} current | awk '{ print $1 }')"

			popd &>/dev/null
		''
		)
	];
}
