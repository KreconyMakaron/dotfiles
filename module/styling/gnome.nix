{ config, lib, ... }: with lib; let
  cfg = config.style.desktopEnvironment.gnome;
in {
  config = mkIf cfg.enable {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome = {
        core-apps.enable = false;
        core-developer-tools.enable = false;
        games.enable = false;
      };
    };

    environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];

    programs.dconf.enable = true;
  };
}
