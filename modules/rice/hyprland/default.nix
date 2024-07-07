{
	inputs,
	pkgs,
	lib,
	theme,
	...
}: {
	imports = [./config.nix ./binds.nix ./rules.nix ./cursor.nix];
	wayland.windowManager.hyprland = {
		enable = true;
		settings.exec-once = [
			"${lib.getExe pkgs.wl-clip-persist} --clipboard both"
			"${lib.getExe' pkgs.wl-clipboard "wl-paste"} --watch cliphist store"
		];
		package = inputs.hyprland.packages.${pkgs.system}.hyprland;
		systemd = {
			variables = ["--all"];
			extraCommands = [
				"systemctl --user stop graphical-session.target"
				"systemctl --user start hyprland-session.target"
			];
		};
	};

	home.packages = with pkgs; with inputs.hyprcontrib.packages.${pkgs.system}; [
		brightnessctl
		swaybg
		pavucontrol
		wl-clipboard
		wl-clip-persist
		cliphist

		# dependencies of grimblast
		grim
		slurp
		hyprpicker
		grimblast
	];

	systemd.user.services = {
		wallpaper-setter = {
			Unit = {
				After = ["graphical-session.target"];
				PartOf = ["graphical-session.target"];
				Description = "Sets the wallpaper";
			};
			Service = {
				Type = "simple";
				ExecStart = "${lib.getExe pkgs.swaybg} -i ${theme.wallpaper}";
				Restart = "always";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
}
