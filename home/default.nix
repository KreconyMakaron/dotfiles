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
		neovim
		kitty
		firefox-devedition-unwrapped

		# move to neovim config
		clang
		nixd
	];
}
