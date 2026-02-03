{
  user,
  lib,
  pkgs,
  ...
}: {
  hm.programs.vscode = {
    enable = lib.mkDefault true;
  };

  settings.nix.unfreePackages = [
    "vscode"
  ];
}
