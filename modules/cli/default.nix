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
		(writeShellScriptBin "rebuild"
		''
			pushd ~/.dotfiles &>/dev/null
			echo "Looking for redundant code..."
			deadnix -e
			set -e
			${lib.getExe pkgs.git} add .
			echo "NixOS Rebuilding..."
			sudo nixos-rebuild switch --flake . &>nixos-switch.log || (${lib.getExe pkgs.bat} nixos-switch.log | ${lib.getExe ripgrep} error && false)
			${lib.getExe pkgs.git} commit -am "Generation $(nixos-rebuild list-generations 2>/dev/null | ${lib.getExe ripgrep} current | awk '{ print $1 }')"
			popd &>/dev/null
		''
		)
	];
}
