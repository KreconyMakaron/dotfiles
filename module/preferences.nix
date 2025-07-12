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
    desktopFileName = lib.mkOption {
      type = lib.types.str;
      default = desktop;
    };
  };

  mkUserDir = dir:
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

    xdg = {
      userDirs = {
        download = mkUserDir "$HOME/download";
        documents = mkUserDir "$HOME/docs";
        videos = mkUserDir "$HOME/vids";
        music = mkUserDir "$HOME/music";
        pictures = mkUserDir "$HOME/pics";
        desktop = mkUserDir "$HOME/other";
        publicShare = mkUserDir "$HOME/other";
        templates = mkUserDir "$HOME/other";
      };
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
        // {
          XDG_DESKTOP_DIR = cfg.xdg.userDirs.desktop;
          XDG_DOCUMENTS_DIR = cfg.xdg.userDirs.documents;
          XDG_DOWNLOAD_DIR = cfg.xdg.userDirs.download;
          XDG_MUSIC_DIR = cfg.xdg.userDirs.music;
          XDG_PICTURES_DIR = cfg.xdg.userDirs.pictures;
          XDG_PUBLICSHARE_DIR = cfg.xdg.userDirs.publicShare;
          XDG_TEMPLATES_DIR = cfg.xdg.userDirs.templates;
          XDG_VIDEOS_DIR = cfg.xdg.userDirs.videos;
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
          "text/html" = cfg.browser.desktopFileName;
          "x-scheme-handler/http" = cfg.browser.desktopFileName;
          "x-scheme-handler/https" = cfg.browser.desktopFileName;
          "x-scheme-handler/ftp" = cfg.browser.desktopFileName;
          "x-scheme-handler/about" = cfg.browser.desktopFileName;
          "x-scheme-handler/unknown" = cfg.browser.desktopFileName;
          "application/x-extension-htm" = cfg.browser.desktopFileName;
          "application/x-extension-html" = cfg.browser.desktopFileName;
          "application/x-extension-shtml" = cfg.browser.desktopFileName;
          "application/xhtml+xml" = cfg.browser.desktopFileName;
          "application/x-extension-xhtml" = cfg.browser.desktopFileName;
          "application/x-extension-xht" = cfg.browser.desktopFileName;
          "application/json" = cfg.browser.desktopFileName;
          "application/pdf" = cfg.pdf.desktopFileName;

          "audio/*" = cfg.audio.desktopFileName;
          "video/*" = cfg.video.desktopFileName;
          "image/*" = cfg.image.desktopFileName;
        };
      in {
        enable = true;
        addedAssociations = associations;
        defaultApplications = associations;
      };
    };
  };
}
