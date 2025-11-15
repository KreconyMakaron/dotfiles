{
  user,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.style.desktopEnvironment.gnome;

  extensions = with pkgs.gnomeExtensions; [
    appindicator      # tray icons
    blur-my-shell     # adds transparency and blur to gnome
    pano              # clipboard manager
    media-controls    # adds mpris widget
    caffeine          # adds a icon to idle-inhibit
  ];
in {
  config = mkIf cfg.enable {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome = {
        core-os-services.enable = true;
        localsearch.enable = true;

        core-apps.enable = false;
        core-developer-tools.enable = false;
        games.enable = false;
      };
    };

    environment = {
      gnome.excludePackages = with pkgs; [gnome-tour gnome-user-docs];
      systemPackages = with pkgs; [
        pkgs.nautilus
        gnome-clocks
        cheese
      ] ++ extensions;
    };

    services.udev.packages = [pkgs.gnome-settings-daemon];

    preferences.terminal.package = pkgs.gnome-console;

    home-manager.users.${user}.dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = map (x: x.extensionUuid) extensions;
        };
        "org/gnome/desktop/search-providers" = {
          disabled = [];
        };
        "org/gnome/shell/extensions/blur/blur-my-shell" = {
          brightness = 0.75;
          noise-amount = 0;
        };
        "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      };
    };
  };
}
