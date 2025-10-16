{
  user,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.style.desktopEnvironment.gnome;
in {
  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        displayManager.gdm.enable = true;
        desktopManager.gnome.enable = true;
      };
      gnome = {
        core-apps.enable = false;
        core-developer-tools.enable = false;
        games.enable = false;
        localsearch.enable = true;
      };
    };

    environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];

    environment.systemPackages = with pkgs; [
      pkgs.nautilus
      gnomeExtensions.user-themes
      gnome-clocks
      cheese
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    };

    preferences.terminal.package = pkgs.gnome-console;

    home-manager.users.${user}.dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          enabled-extensions = [
            pkgs.gnomeExtensions.user-themes.extensionUuid
          ];
        };
        "org/gnome/desktop/search-providers" = {
          disabled = [];
        };
      };
    };
  };
}
