{ 
	pkgs, 
	... 
}: {
	home.stateVersion = "22.11";

	imports = [
		./rice
		./cli
	];

	home.packages = with pkgs; [
		kitty
		firefox-devedition-unwrapped
		(writeShellScriptBin
			"rebuild"
			''
				set -e
				genfile=/tmp/nixos-generations
				pushd ~/.dotfiles &>/dev/null
				git diff -U0 *.nix
				echo "NixOS Rebuilding..."
				sudo nixos-rebuild switch --flake . &>nixos-switch.log || (cat nixos-switch.log | rg error && false)
				nixos-rebuild list-generations &> $genfile
				git commit -am "Generation $(rg current $genfile | awk '{ print $1 }')"
				rm $genfile
				popd &>/dev/null
			''
		)
	];
}
