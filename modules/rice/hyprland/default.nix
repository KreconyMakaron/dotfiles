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
		hyprpicker
		swaybg
		pavucontrol
		wl-clipboard
		wl-clip-persist
		cliphist
		(writeShellScriptBin "startHyprland"
		''
			cd ~
			export XCURSOR_SIZE=20
			exec Hyprland
		'')
	];

	systemd.user.services = let
		GraphicalService = {description, execstart, restart ? "no", type ? "simple"}: {
			Unit = {
				After = ["graphical-session.target"];
				PartOf = ["graphical-session.target"];
				Description = description;
			};
			Service = {
				Type = type;
				ExecStart = execstart;
				Restart = restart;
			};
			Install.WantedBy = ["graphical-session.target"];
		};
		in {
		wallpaper-setter = GraphicalService {
			description = "Sets the wallpaper";
			execstart = "${lib.getExe pkgs.swaybg} -i ${theme.wallpaper}";
			restart = "always";
		};
	};
}
