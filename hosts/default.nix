{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;

  mkHost = name: system:
    nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
        [
          {
            networking.hostName = name;
            nixpkgs.hostPlatform = system;
          }
          ./${name}

          home-manager-module
          {home-manager = home;}
        ]
        ++ builtins.attrValues self.nixosModules;

      specialArgs = {
        inherit inputs;
        inherit system;
      };
    };

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
        imports = [./zephyr/home.nix];
      };
    };
  };
in {
  # huawei Laptop
  zephyr = mkHost "zephyr" "x86_64-linux";
}
