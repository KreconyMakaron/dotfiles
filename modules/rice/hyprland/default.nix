{
	inputs,
	pkgs,
	lib,
	theme,
	...
}:
with lib; let
	mkService = lib.recursiveUpdate {
		Unit.PartOf = ["graphical-session.target"];
		Unit.After = ["graphical-session.target"];
		Install.WantedBy = ["graphical-session.target"];
	};
in {
	imports = [./config.nix ./binds.nix ./rules.nix ./cursor.nix];
	wayland.windowManager.hyprland = {
		enable = true;
		package = inputs.hyprland.packages.${pkgs.system}.hyprland;
		systemd = {
			variables = ["--all"];
			extraCommands = [
				"systemctl --user stop graphical-session.target"
				"systemctl --user start hyprland-session.target"
			];
		};
	};

	home.packages = with pkgs;
	with inputs.hyprcontrib.packages.${pkgs.system}; [
		brightnessctl
		hyprpicker
		swaybg
		pavucontrol
		wl-clipboard
		wl-clip-persist
		(writeShellScriptBin "startHyprland"
		''
			cd ~
			export XCURSOR_SIZE=20
			exec Hyprland
		'')
	];

	systemd.user.services = {
		bgchooser = mkService {
			Unit.Description = "Wallpaper chooser";
			Service = {
				ExecStart = "${lib.getExe pkgs.swaybg} -i ${theme.wallpaper}";
				Restart = "always";
			};
		};
	};
}
