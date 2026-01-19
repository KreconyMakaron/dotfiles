{user, lib, pkgs, ...}: {
  home-manager.users.${user}.programs.vscode = {
    enable = lib.mkDefault true;
    extensions = with pkgs.vscode-extensions; [

    ];
  };
}
