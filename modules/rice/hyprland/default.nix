{ 
	config, 
	inputs,
	pkgs,
	...
}: {
  imports = [ ./config.nix ./binds.nix ];

	home.packages = with pkgs; [
		brightnessctl
	];

  wayland.windowManager.hyprland = {
    enable = true;
		package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
}

