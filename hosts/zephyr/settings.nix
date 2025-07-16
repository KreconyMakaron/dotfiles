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
      defaultGateway = {
        interface = "wlp0s20f3";
        address = "192.168.0.1";
      };
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

  home-manager.users.krecony.services.ags = {
    enable = true;
    autostart = true;
  };

  environment.systemPackages = with pkgs; [
    microfetch
    mangal # real cool manga reader
    libqalculate # best calculator

    tldr # manpages but short
    fzf # fuzzy searching
    unzip # well unzips stuff
    killall # useful when i fuck up
    # hyperfine			# program benchmark tool
    qrcp # cool file sharing through local network
    obsidian # notetaking
    spotify # music
    # brave
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
}
