{user, lib, pkgs, ...}: {
  home-manager.users.${user}.programs.vscode = {
    enable = lib.mkDefault true;
  };

  settings.nix.unfreePackages = [
    "vscode"
  ];
}
