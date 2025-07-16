{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.preferences;

  mkDefaultApp = pkg: desktop: {
    package = mkOption {
      type = types.package;
      default = pkg;
    };
    desktopFile = mkOption {
      type = types.str;
      default = desktop;
    };
  };

  mkDir = dir:
    mkOption {
      type = types.str;
      default = dir;
    };
in {
  options.preferences = {
    editor.package = mkOption {
      type = types.package;
      default = pkgs.neovim;
    };

    browser = mkDefaultApp pkgs.brave "brave-browser.desktop";
    pdf = mkDefaultApp pkgs.zathura "org.pwmt.zathura.desktop";
    image = mkDefaultApp pkgs.imv "imv.desktop";
    audio = mkDefaultApp pkgs.mpv "mpv.desktop";
    video = mkDefaultApp pkgs.mpv "mpv.desktop";

    userDirs = {
      download = mkDir "$HOME/download";
      documents = mkDir "$HOME/docs";
      videos = mkDir "$HOME/vids";
      music = mkDir "$HOME/music";
      pictures = mkDir "$HOME/pics";
      desktop = mkDir "$HOME/other";
      publicShare = mkDir "$HOME/other";
      templates = mkDir "$HOME/other";
    };

    mimeApps.enable = mkOption {
      type = types.bool;
      default = true;
    };
    userDirs.enable = mkOption {
      type = types.bool;
      default = true;
    };
  };

  config = {
    environment = {
      systemPackages = [
        cfg.editor.package
      ];
      sessionVariables = {
        BROWSER = "${getExe cfg.browser.package}";
        EDITOR = "${getExe cfg.editor.package}";
      };
    };

    home-manager.users.krecony.home.packages = [
      cfg.browser.package
      cfg.pdf.package
      cfg.image.package
      cfg.audio.package
      cfg.video.package
    ];

    home-manager.users.krecony.xdg = {
      portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };

      userDirs =
        {
          inherit (cfg.userDirs) enable;
          createDirectories = false;
        }
        // cfg.userDirs;

      mimeApps = let
        associations = {
          "text/html" = cfg.browser.desktopFile;
          "x-scheme-handler/http" = cfg.browser.desktopFile;
          "x-scheme-handler/https" = cfg.browser.desktopFile;
          "x-scheme-handler/ftp" = cfg.browser.desktopFile;
          "x-scheme-handler/about" = cfg.browser.desktopFile;
          "x-scheme-handler/unknown" = cfg.browser.desktopFile;
          "application/x-extension-htm" = cfg.browser.desktopFile;
          "application/x-extension-html" = cfg.browser.desktopFile;
          "application/x-extension-shtml" = cfg.browser.desktopFile;
          "application/xhtml+xml" = cfg.browser.desktopFile;
          "application/x-extension-xhtml" = cfg.browser.desktopFile;
          "application/x-extension-xht" = cfg.browser.desktopFile;
          "application/json" = cfg.browser.desktopFile;
          "application/pdf" = cfg.pdf.desktopFile;

          "audio/*" = cfg.audio.desktopFile;
          "video/*" = cfg.video.desktopFile;
          "image/*" = cfg.image.desktopFile;
        };
      in {
        inherit (cfg.mimeApps) enable;
        defaultApplications = associations;
        associations.added = associations;
      };
    };
  };
}
