{pkgs, ...}: {
	home.packages = with pkgs; [
		mpv
		imv
		obsidian
		spotify
	];

	programs.zathura.enable = true;

	imports = [
		./xdg.nix
		./firefox.nix
		./vesktop.nix
	];
}
