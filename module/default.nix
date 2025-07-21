{
  config,
  lib,
  pkgs,
  ...
}: let
  importWithStuff = path:
    import path {
      inherit config lib pkgs;
      inherit (config.core) user;
      inherit (config.lib.stylix) colors;
    };
in {
  imports = builtins.map importWithStuff [
    ./core.nix
    ./shell.nix
    ./preferences.nix
    ./git.nix
    ./network.nix
    ./style.nix
    ./zsh.nix
  ];
}
