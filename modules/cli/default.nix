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
		./starship.nix
	];
	home.packages = with pkgs; [
		ripgrep
		hyperfine
		jq
		unzip
		qrcp
		killall
		lazygit
	];
}
