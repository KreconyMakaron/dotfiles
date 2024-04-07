{
	pkgs, 
	lib, 
	...
}: {
	imports = [
		./fastfetch.nix
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
		killall
		lazygit
		(writeShellScriptBin "rebuild"
		''
			deadnixoutput=/tmp/deadnixoutput
			nixosrebuild=/tmp/nixosrebuild.log
			dotfiles=~/.dotfiles

			host=$1

			spinner() {
				pid=$!

				spin='▁▂▃▄▅▆▇█'
				i=0
				while kill -0 $pid 2>/dev/null
				do
					i=$(( (i+1) %8 ))
					printf "\r$1 ''${spin:$i:1} "
					sleep .1
				done
			}

			success() {
				printf "\r$1 \e[32m✓\e[0m"
			}

			fail() {
				printf "\r$1 \e[31m✗\e[0m"
			}

			pushd $dotfiles &>/dev/null

			${lib.getExe pkgs.deadnix} &>$deadnixoutput &
			spinner "Looking for unused code..."
			deadout=$(${lib.getExe pkgs.bat} -pp $deadnixoutput) 

			if [[ "$deadout" == "" ]]; then
				success "Looking for unused code..."
			else
				fail "Looking for unused code..."
				printf "\n$deadout\n"
				if read -p "Refactor? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
					${lib.getExe pkgs.deadnix} -e &>/dev/null
				fi
			fi

			${lib.getExe pkgs.git} add .
			echo ""


			sudo nixos-rebuild switch --flake .#$host &>$nixosrebuild &
			spinner "Rebuilding system..."

			if wait $pid; then
				success "Rebuilding system..."
				echo ""
				${lib.getExe pkgs.git} commit -am "Generation $(nixos-rebuild list-generations 2>/dev/null | ${lib.getExe ripgrep} current | awk '{ print $1 }')"
			else
				fail "Rebuilding system..."
				echo ""
				${lib.getExe pkgs.bat} -pp $nixos-rebuild | ${lib.getExe pkgs.ripgrep} error

				sudo ${lib.getExe pkgs.git} restore --staged ./**/*.nix

				if read -p "Open log? (y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
					$EDITOR $nixosrebuild
				fi

				popd &>/dev/null
				exit 1
			fi

		''
		)
	];
}
