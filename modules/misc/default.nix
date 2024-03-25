{pkgs, ...}: {
	home.packages = with pkgs; [
		mpv
		imv
	];

	imports = [
		./xdg.nix
		./zathura.nix
	];
}
