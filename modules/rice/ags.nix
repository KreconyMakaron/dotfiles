{inputs, pkgs, lib, ...}: {

	systemd.user.services = {
		ags = {
			Unit = {
				After = ["graphical-session.target"];
				PartOf = ["graphical-session.target"];
				Description = "Starts Aylur's Gtk Shell";
			};
			Service = {
				Type = "simple";
				ExecStart = "${lib.getExe' inputs.ags.packages.${pkgs.system}.default "kreshell"}";
				Restart = "always";
			};
			Install.WantedBy = ["graphical-session.target"];
		};
	};
}
