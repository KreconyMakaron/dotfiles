{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  extensions = with pkgs.gnomeExtensions; [
    appindicator # tray icons
    blur-my-shell # adds transparency and blur to gnome
    # (pkgs.callPackage ./copyous.nix { inherit pkgs; }) # clipboard
    media-controls # adds mpris widget
    caffeine # provides idle-inhibit on demand
    tiling-shell # adds tiling support
  ];
in
{
  config = mkIf (config.style.desktopEnvironment == "gnome") {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome = {
        # gnome is bad without these
        core-os-services.enable = true;
        core-shell.enable = true;
        localsearch.enable = true; # global file and option search

        gnome-keyring.enable = true; # needed for some apps

        # bloat apps
        core-apps.enable = false;
        core-developer-tools.enable = false;
        games.enable = false;

        # more bloat
        gnome-remote-desktop.enable = false; # RDP/VNC remote desktop server
        rygel.enable = false; # UPnP/DLNA media server
        gnome-user-share.enable = false; # WebDAV personal file sharing
        gnome-browser-connector.enable = false; # allows enabling extensions from browser
        gnome-online-accounts.enable = false; # accounts in gnome like Google
        gnome-initial-setup.enable = false; # initial setup script

      };
      geoclue2.enable = false; # geolocation
      dleyna.enable = false; # UPnP/DLNA media controller (D-Bus)
      avahi.enable = false; # mDNS responder
    };

    security.pam.services.login.enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;

    settings.userPackages = with pkgs; [
      baobab
      komikku
      resources
      gnome-calendar
      gnome-clocks
      gnome-disk-utility
    ];

    environment = {
      gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];
      systemPackages = [ pkgs.nautilus ] ++ extensions;
    };

    services.udev.packages = [ pkgs.gnome-settings-daemon ];

    preferences.terminal = pkgs.gnome-console;

    hm.dconf = {
      enable = true;
      settings = mkMerge [
        {
          "org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = map (x: x.extensionUuid) extensions;
          };
          "org/gnome/desktop/search-providers" = {
            disabled = [ ];
          };
          "org/gnome/shell/extensions/blur/blur-my-shell" = {
            brightness = 0.75;
            noise-amount = 0;
          };
          "org/gnome/desktop/interface".color-scheme = "prefer-dark";
          "org/gnome/shell/extensions/tiling/shell" = {
            inner-gaps = 0;
            outer-gaps = 0;
            enable-tiling-system = true;
          };
          # disable accessibility menu on the login screen
          "org/gnome/desktop/a11y".always-show-universal-access-status = false;
          "org/gnome/shell".always-show-log-out = true;
        }
        (import ./binds.nix { inherit config lib; })
      ];
    };
  };
}
