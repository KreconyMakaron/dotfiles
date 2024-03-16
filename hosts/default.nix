{
	nixpkgs,
	self,
	...
}: let
	inherit (self) inputs;
	core = ../system/core;
	wayland = ../system/wayland;
	home-manager-module = inputs.home-manager.nixosModules.home-manager;
	home-manager = {
		useUserPackages = true;
		useGlobalPkgs = true;
		extraSpecialArgs = { 
			inherit inputs; 
			inherit self;
		};
		users.krecony.imports = [ ../home ];
	};
in {
	#Huawei Laptop
	zephyr = nixpkgs.lib.nixosSystem {
		system = "x86_64-linux";
		modules = [
			{networking.hostName = "zephyr";}
			./zephyr
			core
			wayland
			home-manager-module {inherit home-manager;}
		];
		specialArgs = {inherit inputs;};
	};
}
