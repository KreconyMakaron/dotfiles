{inputs, pkgs, ...}: {
	home.stateVersion = "22.11";

	imports = [
		../../modules/cli
		../../modules/rice
		../../modules/misc
		../../modules/fixes/alsa-fixes.nix
		inputs.hyprlock.homeManagerModules.default
	];

	home.packages = with pkgs; [
		firefox-devedition-unwrapped
	];
}
