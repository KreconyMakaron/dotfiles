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
    ./shell.nix
    ./preferences.nix
    ./git.nix
    ./zsh.nix
    ./firefly.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./foot.nix

    ./styling
    ./networking
    ./system
  ];
}
