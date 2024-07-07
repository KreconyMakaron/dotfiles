{
	inputs, 
	pkgs,
	lib,
	...
}: {
	imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;
    configDir = ../ags;
    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
    ];
  };

	systemd.user.services = {
		ags = {
			Unit = {
				After = ["graphical-session.target"];
				PartOf = ["graphical-session.target"];
				Description = "Starts Aylur's Gtk Shell";
			};
			Service = {
				Type = "simple";
				ExecStart = "${lib.getExe pkgs.ags}";
				Restart = "always";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
}
