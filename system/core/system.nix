{
	lib, 
	pkgs, 
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

	environment = {
		variables = {
			EDITOR = "nvim";
			BROWSER = "firefox-devedition";
		};

		systemPackages = with pkgs; [
			git
			appimage-run
		];
	};

	hardware = {
		enableAllFirmware = true;
		opengl.enable = true;
		opengl.driSupport32Bit = true;
	};

	programs.nix-ld.enable = true;
	boot.binfmt.registrations = lib.genAttrs ["appimage" "AppImage"] (ext: {
    recognitionType = "extension";
    magicOrExtension = ext;
    interpreter = "${lib.getExe' pkgs.appimage-run "appimage-run"}";
  });

	console.keyMap = "pl2";

	programs.java = {
		enable = true;
		package = pkgs.jre;
	};

	services = {
		upower.enable = true;
		mysql = {
			enable = true;
			package = pkgs.mariadb;
		};
		openssh.enable = true;
	};

	programs.dconf.enable = true;
}
