{config, lib, pkgs, ...}: let
  importWithUser = path: import path {
    inherit config lib pkgs;
    inherit (config.core) user;
  };
in {
  imports = builtins.map importWithUser [
    ./core.nix
    ./preferences.nix
    ./git.nix
    ./network.nix
  ];
}
