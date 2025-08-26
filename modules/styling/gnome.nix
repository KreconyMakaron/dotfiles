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
      };
    };

    environment.gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];

    environment.systemPackages = with pkgs; [
      gnomeExtensions.user-themes
    ];

    preferences.terminal.package = pkgs.gnome-console;

    programs.dconf.enable = true;
  };
}
