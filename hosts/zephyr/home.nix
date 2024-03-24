{pkgs, ...}: {
	home.stateVersion = "22.11";

	imports = [
		../../modules/cli
		../../modules/rice
		../../modules/misc
		./alsa-fixes.nix
	];

	home.packages = with pkgs; [
		firefox-devedition-unwrapped
	];
}
