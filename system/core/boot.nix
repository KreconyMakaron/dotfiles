{
	pkgs, 
	lib,
	...
}: {
	boot = {
		loader = {
			systemd-boot = {
				enable = true;
				configurationLimit = 10;
			};
			efi.canTouchEfiVariables = true;
			timeout = 0;
		};
		plymouth = {
			enable = true;
			themePackages = with pkgs; [ (adi1090x-plymouth-themes.override {selected_themes = [ "lone" ]; }) ];
      theme = "lone";
		};
		initrd = {
			verbose = false;
			systemd.enable = true;
		};
		kernelParams = [ 
			"logo.nologo"
			"fbcon=nodefer"
			"bgrt_disable"
			"vt.global_cursor_default=0"
			"quiet"
			"systemd.show_status=false"
			"rd.udev.log_level=3"
			"splash"
		];
		consoleLogLevel = 3;
	};

	environment.systemPackages = [ pkgs.greetd.tuigreet ];
	services.greetd = {
		enable = true;
		settings = rec {
			default_session = {
				command = ''${lib.getExe pkgs.greetd.tuigreet} --greeting "siema mordo" --time --cmd ${lib.getExe' pkgs.hyprland "Hyprland"}'';
				user = "greeter";
			};
		};
	};
}
