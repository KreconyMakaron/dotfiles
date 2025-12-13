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

  services = {
    postgresql = {
      enable = true;
      ensureDatabases = ["mydatabase"];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
        # ipv4
        host  all      all     127.0.0.1/32   trust
        # ipv6
        host all       all     ::1/128        trust
      '';
      enableTCPIP = true;
      port = 5432;
    };

    pgadmin = {
      enable = true;
      initialEmail = "admin@example.com";
      initialPasswordFile = "/home/krecony/other/pgadminpass";
      port = 5050;
      settings.authentication = ''
        # Allow local socket connections
        local   all   all                          trust

        # Allow IPv4 localhost
        host    all   all   127.0.0.1/32           trust

        # Allow IPv6 localhost
        host    all   all   ::1/128                trust
      '';
    };
  };
}
