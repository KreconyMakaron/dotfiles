{pkgs, pkgs-latest, ...}: {
	home.packages = with pkgs; [
		obsidian	# notetaking
		spotify		# music
		# brave
    librewolf
		proton-pass
    protonmail-desktop
		protonvpn-gui
		nautilus
		nautilus-open-any-terminal
    zathura
    libreoffice-qt
    pkgs-latest.osu-lazer-bin
    opentabletdriver
    jetbrains.pycharm-professional
    vesktop
	];

	programs = {
		# image viewing
		imv.enable = true;

		# video viewer
		mpv = {
			enable = true;
			config = {
				hwdec = "auto-safe";
				vo = "gpu";
				profile = "gpu-hq";
				gpu-context = "wayland";
			};
		};
	};

	# bluetooth headset media buttons support
	services.mpris-proxy.enable = true;

	imports = [
		./xdg.nix
		# ./vesktop.nix
		./hypridle.nix
	# ./firefox.nix
	];
}
