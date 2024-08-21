{pkgs, ...}: {
	home.packages = with pkgs; [
		mpv				# video viewing
		imv				# image viewing
		obsidian	# notetaking
		spotify		# music
	];

	programs.zathura.enable = true; # pdf viewer

	imports = [
		./xdg.nix
		./firefox.nix
		./vesktop.nix
	];
}
