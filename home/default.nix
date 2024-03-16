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
	];
}
