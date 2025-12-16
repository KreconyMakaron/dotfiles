{
  lib,
  inputs,
  pkgs,
  system,
  ...
}: {
  hardware = {
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
  };

  powerManagement.enable = true;

  core = {
    user = "krecony";
    flakePath = "/home/krecony/dotfiles/";
  };

  preferences = {
    editor.package = inputs.nixvim.packages.${system}.default;
    pdf = {
      package = pkgs.papers;
      desktopFile = "org.gnome.Papers.desktop";
    };

    video = {
      package = pkgs.showtime;
      desktopFile = "org.gnome.Showtime.desktop";
    };

    image = {
      package = pkgs.loupe;
      desktopFile = "org.gnome.Loupe.desktop";
    };

    vpn.enable = true;

    sql = {
      postgresql.enable = true;
      pgadmin.enable = true;
    };
  };

  style = {
    theme = "everforest";
    desktopEnvironment.gnome.enable = true;
    displayServer.wayland.enable = true;
    widgets.ags.enable = false;
  };

  environment.systemPackages = with pkgs; [
    sof-firmware
    alsa-utils
  ];

  nixpkgs.overlays = [
    (self: super: let
      lmms-fix-pkgs = import inputs.lmms-nixpkgs {inherit system;};
    in {
      inherit (lmms-fix-pkgs) lmms;
    })
  ];

  home-manager.users.krecony = {
    home.packages = with pkgs; [
      lmms

      scenebuilder

      libreoffice-qt
      obsidian
      anki
      spotify
      vesktop # discord client

      jetbrains.pycharm-professional
      jetbrains.idea-ultimate

      # pdf edditing with math
      xournalpp
      texliveFull

      # nice gnome apps
      baobab
      gnome-logs
      komikku
      resources
      wike
      gnome-calendar

      # nice latex alternative
      typst
    ];

    # huawei laptop go brrrr
    systemd.user.services.alsa-fixes = {
      Unit.Description = "Enable Speakers";
      Service = {
        RemainAfterExit = true;
        Type = "oneshot";
        ExecStart = [
          "${lib.getExe' pkgs.alsa-utils "amixer"} -c 0 cset 'numid=69' 1"
          "${lib.getExe' pkgs.alsa-utils "amixer"} -c 0 cset 'numid=70' 1"
          "${lib.getExe' pkgs.alsa-utils "amixer"} -c 0 cset 'numid=71' 1"
          "${lib.getExe' pkgs.alsa-utils "amixer"} -c 0 cset 'numid=72' 1"
        ];
      };
      Install.WantedBy = ["default.target"];
    };
  };

  firefly-iii = {
    enable = true;
    enableDataImporter = true;
    databasePasswordFile = "/var/secrets/firefly-db-key";
    appKeyFile = "/var/secrets/firefly-app-key";
  };
}
