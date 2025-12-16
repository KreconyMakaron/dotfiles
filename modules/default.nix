{
  config,
  lib,
  pkgs,
  inputs,
  system,
  ...
}: let
  importWithStuff = path:
    import path {
      inherit config lib pkgs inputs system importWithStuff;
      inherit (config.core) user;
      inherit (config.lib.stylix) colors;
    };
in {
  imports = builtins.map importWithStuff [
    ./core.nix
    ./preferences.nix
    ./gaming.nix

    ./networking
    ./programs
    ./shell
    ./styling
    ./system
  ];
}
