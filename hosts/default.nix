{
  nixpkgs,
  self,
  ...
}: let
  inherit (self) inputs;
  core = ../system/core;
  wayland = ../system/wayland;
  home-manager-module = inputs.home-manager.nixosModules.home-manager;

  home = path: {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.krecony = {
      imports = [path];
      _module.args.theme = import ../theme;
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
      wayland
      home-manager-module
      {home-manager = home ../home/zephyr.nix;}
    ];
    specialArgs = {inherit inputs;};
  };
}
