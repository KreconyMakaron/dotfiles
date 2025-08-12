{
  config,
  lib,
  inputs,
  pkgs,
  system,
  ...
}: {
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableAllFirmware = true;
  };

  powerManagement.enable = true;

  core = {
    user = "krecony";
  };

  preferences = {
    editor.package = inputs.nixvim.packages.${system}.default;

    vpn = {
      enable = true;
      disabledIPs = [
        # nixos.wiki gets mad
        "172.67.75.217"
        "104.26.14.206"
        "104.26.15.206"
      ];
      dns = ["10.2.0.1"];
      address = ["10.2.0.2/32"];
      privateKeyDir = "/root/protonvpn-keys";
      servers = {
        poland = {
          autostart = true;
          publicKey = "wpfRQRhJirL++QclFH6SDhc+TuJJB4UxbCABy7A1tS4=";
          endpoint = "79.127.186.193:51820";
        };
      };
    };
  };

  style = {
    theme = "everforest";
    desktopEnvironment.Hyprland.enable = true;
    displayServer.wayland.enable = true;
    widgets.ags.enable = true;
  };

  environment.systemPackages = with pkgs; [
    sof-firmware
    alsa-utils
  ];

  home-manager.users.krecony = {
    services.ags = {
      enable = true;
      hyprlandIntegration = {
        enable = true;
        autostart.enable = true;
        keybinds.enable = true;
      };
    };

    home.packages = with pkgs; [
      mangal # real cool manga reader

      obsidian # notetaking
      spotify # music
      proton-pass
      protonmail-desktop
      protonvpn-gui
      nautilus
      nautilus-open-any-terminal
      # zathura
      libreoffice-qt
      opentabletdriver
      jetbrains.pycharm-professional
      vesktop
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
}
