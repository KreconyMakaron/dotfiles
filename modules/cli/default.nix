{pkgs, ...}: {
	imports = [
		./zsh.nix
		./tools.nix
		./git.nix
		./neovim.nix
	];
	home.packages = with pkgs; [
		ripgrep
		hyperfine
		jq
		unzip
		qrcp
		neofetch
		killall
		(writeShellScriptBin "rebuild"
		''
			pushd ~/.dotfiles &>/dev/null
			echo "Looking for redundant code..."
			deadnix -e
			set -e
			git add .
			echo "NixOS Rebuilding..."
			sudo nixos-rebuild switch --flake . &>nixos-switch.log || (cat nixos-switch.log | rg error && false)
			git commit -am "Generation $(nixos-rebuild list-generations 2>/dev/null | rg current | awk '{ print $1 }')"
			popd &>/dev/null
		''
		)
	];
}
