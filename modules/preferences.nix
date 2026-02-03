{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
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

  mkDir =
    dir:
    mkOption {
      type = types.str;
      default = dir;
    };
in
{
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
    terminal = {
      package = mkOption {
        type = types.package;
        default = pkgs.foot;
      };
      swallowClassRegex = mkOption {
        type = types.str;
        default = "^(foot)";
      };
    };

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

    settings.userPackages = [
      cfg.browser.package
      cfg.pdf.package
      cfg.image.package
      cfg.audio.package
      cfg.video.package
      cfg.terminal.package
    ];

    hm.xdg = {
      enable = true;

      userDirs = {
        inherit (cfg.userDirs) enable;
        createDirectories = false;
      }
      // cfg.userDirs;

      mimeApps =
        let
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

            "audio/3gpp" = cfg.audio.desktopFile;
            "audio/3gpp2" = cfg.audio.desktopFile;
            "audio/aac" = cfg.audio.desktopFile;
            "audio/ac3" = cfg.audio.desktopFile;
            "audio/flac" = cfg.audio.desktopFile;
            "audio/midi" = cfg.audio.desktopFile;
            "audio/mp2" = cfg.audio.desktopFile;
            "audio/mp3" = cfg.audio.desktopFile;
            "audio/mp4" = cfg.audio.desktopFile;
            "audio/mpeg" = cfg.audio.desktopFile;
            "audio/mpeg3" = cfg.audio.desktopFile;
            "audio/ogg" = cfg.audio.desktopFile;
            "audio/opus" = cfg.audio.desktopFile;
            "audio/wav" = cfg.audio.desktopFile;
            "audio/webm" = cfg.audio.desktopFile;
            "audio/x-aiff" = cfg.audio.desktopFile;
            "audio/x-flac" = cfg.audio.desktopFile;
            "audio/x-m4a" = cfg.audio.desktopFile;
            "audio/x-mp3" = cfg.audio.desktopFile;
            "audio/x-ms-wma" = cfg.audio.desktopFile;
            "audio/x-wav" = cfg.audio.desktopFile;
            "audio/x-vorbis+ogg" = cfg.audio.desktopFile;

            "video/3gpp" = cfg.video.desktopFile;
            "video/3gpp2" = cfg.video.desktopFile;
            "video/avi" = cfg.video.desktopFile;
            "video/divx" = cfg.video.desktopFile;
            "video/mp2t" = cfg.video.desktopFile;
            "video/mp4" = cfg.video.desktopFile;
            "video/mp4v-es" = cfg.video.desktopFile;
            "video/mpeg" = cfg.video.desktopFile;
            "video/mpeg4" = cfg.video.desktopFile;
            "video/ogg" = cfg.video.desktopFile;
            "video/quicktime" = cfg.video.desktopFile;
            "video/webm" = cfg.video.desktopFile;
            "video/x-flv" = cfg.video.desktopFile;
            "video/x-matroska" = cfg.video.desktopFile;
            "video/x-ms-asf" = cfg.video.desktopFile;
            "video/x-ms-wmv" = cfg.video.desktopFile;
            "video/x-msvideo" = cfg.video.desktopFile;
            "video/x-theora+ogg" = cfg.video.desktopFile;
            "video/x-ogm+ogg" = cfg.video.desktopFile;

            "image/avif" = cfg.image.desktopFile;
            "image/bmp" = cfg.image.desktopFile;
            "image/gif" = cfg.image.desktopFile;
            "image/heic" = cfg.image.desktopFile;
            "image/heif" = cfg.image.desktopFile;
            "image/ico" = cfg.image.desktopFile;
            "image/jpeg" = cfg.image.desktopFile;
            "image/jxl" = cfg.image.desktopFile;
            "image/png" = cfg.image.desktopFile;
            "image/svg+xml" = cfg.image.desktopFile;
            "image/tiff" = cfg.image.desktopFile;
            "image/webp" = cfg.image.desktopFile;
            "image/x-xbitmap" = cfg.image.desktopFile;
            "image/x-xpixmap" = cfg.image.desktopFile;
            "image/x-tga" = cfg.image.desktopFile;
            "image/x-portable-bitmap" = cfg.image.desktopFile;
            "image/x-portable-graymap" = cfg.image.desktopFile;
            "image/x-portable-pixmap" = cfg.image.desktopFile;
            "image/x-portable-anymap" = cfg.image.desktopFile;
            "image/x-ms-bmp" = cfg.image.desktopFile;
          };
        in
        {
          inherit (cfg.mimeApps) enable;
          defaultApplications = associations;
          associations.added = associations;
        };
    };
  };
}
