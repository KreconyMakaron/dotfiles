{
  lib,
  ...
}:
{
  hm.programs.vscode = {
    enable = lib.mkDefault true;
  };

  settings.nix.unfreePackages = [
    "vscode"
  ];
}
