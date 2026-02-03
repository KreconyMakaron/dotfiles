{
  outputs = inputs @ {nixpkgs, ...}: let
    forAllSystems = nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  in {
    formatter = forAllSystems (
      system: nixpkgs.legacyPackages.${system}.nixfmt-tree
    );

    homeManagerModules = {
      ags = inputs.ags.homeManagerModules.default;
    };

    nixosModules = {
      inherit (inputs.stylix.nixosModules) stylix;
      inherit (inputs.musnix.nixosModules) musnix;
      inherit (inputs.nix-mineral.nixosModules) nix-mineral;
      inherit (inputs.home-manager.nixosModules) home-manager;
    };

    nixosConfigurations = import ./hosts inputs;
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    lmms-nixpkgs.url = "github:wizardlink/nixpkgs/lmms";
    musnix.url = "github:musnix/musnix";
    nix-mineral.url = "github:cynicsketch/nix-mineral/";

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

    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    # ags.url = "github:KreconyMakaron/ags";
    # change later
    ags.url = "path:/home/krecony/code/ags";

    stylix.url = "github:danth/stylix";

    polymc.url = "github:PolyMC/PolyMC";
  };
}
