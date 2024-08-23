{pkgs, ...}: {
	home.packages = with pkgs; [
		mpv				# video viewing
		imv				# image viewing
		obsidian	# notetaking
		spotify		# music
	];

	# pdf viewer
	programs.zathura = {
		enable = true; 
		options.selection-clipboard = "clipboard";
	};

	# bluetooth headset media buttons support
	services.mpris-proxy.enable = true;

	imports = [
		./xdg.nix
		./firefox.nix
		./vesktop.nix
	];
}
