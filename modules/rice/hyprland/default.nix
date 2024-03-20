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
	imports = [./config.nix ./binds.nix ./rules.nix];
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
			hyprctl setcursor 20 HyprBibataModernClassicSVG
			exec Hyprland
		'')
	];

	home.pointerCursor = let
		getFrom = url: hash: name: {
			gtk.enable = true;
			x11.enable = true;
			name = name;
			size = 20;
			package = pkgs.runCommand "moveUp" {} ''
				mkdir -p $out/share/icons
				ln -s ${pkgs.fetchzip {
					url = url;
					hash = hash;
				}} $out/share/icons/${name}
			'';
		};
	in
		getFrom
		"https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz"
		"sha256-jpEuovyLr9HBDsShJo1efRxd21Fxi7HIjXtPJmLQaCU="
		"Bibata-Modern-Classic";

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
