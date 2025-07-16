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

          inputs.home-manager.nixosModules.home-manager

          ({config, ...}: {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {
                inherit inputs self;
                nixosConfig = config;
              };
              users = {
                krecony = {
                  imports =
                    [
                      ./${name}/home.nix
                    ]
                    ++ builtins.attrValues self.homeManagerModules;
                };
              };
            };
          })

          ../system
          ../module
        ]
        ++ builtins.attrValues self.nixosModules;

      specialArgs = {
        inherit inputs;
        inherit system;
      };
    };
in {
  # huawei Laptop
  zephyr = mkHost "zephyr" "x86_64-linux";
}
