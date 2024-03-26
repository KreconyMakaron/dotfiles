{pkgs, ...}: {
	home.packages = with pkgs; [
		mpv
		imv
		obsidian
	];

	imports = [
		./xdg.nix
		./zathura.nix
	];
}
