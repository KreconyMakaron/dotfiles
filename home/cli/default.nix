{ 
	pkgs,
	... 
}: {
	imports = [
		./zsh
		./tools.nix
		./git.nix
	];

	home.packages = with pkgs; [
		ripgrep
		hyperfine
		jq
		unzip
		qrcp
	];
}
