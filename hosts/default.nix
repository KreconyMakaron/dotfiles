{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;

  hmModule = {config, ...}: {
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      extraSpecialArgs = {
        inherit inputs self;
        nixosConfig = config;
      };
      users = {
        ${config.core.user} = {
          home = {
            username = config.core.user;
            homeDirectory = "/home/${config.core.user}";
            stateVersion = "22.11";
          };
          imports = builtins.attrValues self.homeManagerModules;
        };
      };
    };
  };

  hmAliasModule = {lib, config, ...}: {
    imports = [
      (lib.mkAliasOptionModule ["hm"] ["home-manager" "users" config.core.user])
    ];
  };

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

          hmModule
          hmAliasModule

          ../modules
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
