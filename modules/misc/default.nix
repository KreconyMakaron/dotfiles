{pkgs, ...}: {
	home.packages = with pkgs; [
		mpv
		imv
		obsidian

		osu-lazer-bin
	];

	imports = [
		./xdg.nix
		./zathura.nix
		./lock.nix
		./firefox.nix
		./vesktop
	];
}
