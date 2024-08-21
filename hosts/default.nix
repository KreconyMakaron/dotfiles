{
	nixpkgs,
	self,
	...
}: let
	inherit (self) inputs;
	core = ../system/core;
	wayland = ../system/wayland;
	intel-graphics = ../system/intel;

	home-manager-module = inputs.home-manager.nixosModules.home-manager;

	home = {
		useUserPackages = true;
		useGlobalPkgs = true;
		extraSpecialArgs = {
			inherit inputs;
			inherit self;
		};
		users = {
			krecony = {
				imports = [ ./zephyr/home.nix ];
			};
		};
	};
in {
	# huawei Laptop
	zephyr = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
			{networking.hostName = "zephyr";}
			./zephyr
			core
			intel-graphics
			wayland
			home-manager-module
			{home-manager = home;}
		];
		specialArgs = {inherit inputs;};
	};
}
