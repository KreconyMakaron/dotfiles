{
	inputs,
	pkgs,
	lib,
	config,
	...
}: {
	imports = [ 
		./config.nix 
		./binds.nix 
		./rules.nix 
		./cursor.nix 
	];

	home.packages = with pkgs; with inputs.hyprcontrib.packages.${pkgs.system}; [
		brightnessctl
		swaybg
		pavucontrol
		wl-clipboard
		wl-clip-persist
		cliphist

		# dependencies of grimblast
		grimblast
		grim
		slurp
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
				ExecStart = "${lib.getExe pkgs.swaybg} -i ${config.stylix.image}";
				Restart = "always";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
}
