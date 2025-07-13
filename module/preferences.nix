{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.preferences;

  mkDefaultApp = pkg: desktop: {
    package = lib.mkOption {
      type = lib.types.package;
      default = pkg;
    };
    desktopFile = lib.mkOption {
      type = lib.types.str;
      default = desktop;
    };
  };

  mkDir = dir:
    lib.mkOption {
      type = lib.types.str;
      default = dir;
    };
in {
  options.preferences = {
    editor.package = lib.mkOption {
      type = lib.types.package;
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

    baseDirs = {
      data = mkDir "$HOME/.local/share";
      config = mkDir "$HOME/.config";
      state = mkDir "$HOME/.local/state";
      cache = mkDir "$HOME/.cache";
      bin = mkDir "$HOME/.local/bin";
    };
  };

  config = {
    environment = {
      systemPackages = [
        cfg.editor.package
        cfg.browser.package
        cfg.pdf.package
        cfg.image.package
        cfg.audio.package
        cfg.video.package
      ];
      variables =
        {
          BROWSER = "${lib.getExe cfg.browser.package}";
          EDITOR = "${lib.getExe cfg.editor.package}";
        }
        // rec {
          # https://specifications.freedesktop.org/basedir-spec/latest/
          XDG_DESKTOP_DIR = cfg.userDirs.desktop;
          XDG_DOCUMENTS_DIR = cfg.userDirs.documents;
          XDG_DOWNLOAD_DIR = cfg.userDirs.download;
          XDG_MUSIC_DIR = cfg.userDirs.music;
          XDG_PICTURES_DIR = cfg.userDirs.pictures;
          XDG_PUBLICSHARE_DIR = cfg.userDirs.publicShare;
          XDG_TEMPLATES_DIR = cfg.userDirs.templates;
          XDG_VIDEOS_DIR = cfg.userDirs.videos;

          XDG_DATA_HOME = cfg.baseDirs.data;
          XDG_CONFIG_HOME = cfg.baseDirs.config;
          XDG_STATE_HOME = cfg.baseDirs.state;
          XDG_CACHE_HOME = cfg.baseDirs.cache;
          XDG_BIN_HOME = cfg.baseDirs.bin;

          PATH = [
            "${XDG_BIN_HOME}"
          ];
        };
    };

    xdg = {
      portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
      };

      mime = let
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
        enable = true;
        addedAssociations = associations;
        defaultApplications = associations;
      };
    };
  };
}
