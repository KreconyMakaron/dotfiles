{
	lib, 
	pkgs, 
	inputs,
	...
}: {
	time = {
		timeZone = "Europe/Warsaw";
		hardwareClockInLocalTime = false;
	};

	i18n = let
		en = "en_GB.UTF-8";
		pl = "pl_PL.UTF-8";
	in {
		defaultLocale = en;
		extraLocaleSettings = {
			LANG = en;
			LC_ADDRESS = pl;
			LC_IDENTIFICATION = pl;
			LC_MEASUREMENT = pl;
			LC_MONETARY = pl;
			LC_NAME = pl;
			LC_NUMERIC = pl;
			LC_PAPER = pl;
			LC_TELEPHONE = pl;
			LC_TIME = pl;
		};
	};

	console.keyMap = "pl2";

	environment = {
		variables = {
			EDITOR = "nvim";
			BROWSER = "brave";
		};

		systemPackages = with pkgs; [
			git
			appimage-run
			inputs.nixvim.packages.${system}.default
		];
	};

	boot.binfmt.registrations = lib.genAttrs ["appimage" "AppImage"] (ext: {
    recognitionType = "extension";
    magicOrExtension = ext;
    interpreter = "${lib.getExe' pkgs.appimage-run "appimage-run"}";
  });

	programs = {
		nix-ld.enable = true;
		dconf.enable = true;
		xwayland.enable = true;
		java = {
			enable = true;
			package = pkgs.jre;
		};
	};

  virtualisation.docker.enable = true;

	services = {
		upower.enable = true; # ags dependency for battery service
		openssh.enable = true;
		mysql = {
			enable = true;
			package = pkgs.mariadb;
		};
	};
}
