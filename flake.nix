{
  outputs = inputs: {
    nixosModules = {
      system = import ./system;
    }
    // import ./module;

    nixosConfigurations = import ./hosts inputs;
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:mikaelfangel/nixvim-config";

    hyprcontrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

		hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #https://github.com/hyprwm/Hyprland/issues/5891
		hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; 

		xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";

		ags.url = "github:KreconyMakaron/ags";

		stylix.url = "github:danth/stylix";

		polymc.url = "github:PolyMC/PolyMC";
  };
}
