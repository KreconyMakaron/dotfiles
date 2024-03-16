{
	description = "hihi";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		hyprland.url = "github:hyprwm/Hyprland";
	};

	outputs = { self, ... }@inputs: {
		nixosConfigurations = import ./hosts inputs;
	};
}
