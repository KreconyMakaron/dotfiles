{
  description = "hihi";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprcontrib = {
      url = "github:hyprwm/contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
		hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
		hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1"; #https://github.com/hyprwm/Hyprland/issues/5891

		xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";
		ags.url = "github:Aylur/ags";
		stylix.url = "github:danth/stylix";
  };

  outputs = {...} @ inputs: {
    nixosConfigurations = import ./hosts inputs;
  };
}
