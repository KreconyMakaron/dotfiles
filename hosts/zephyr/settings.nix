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

  programs.ags = {
    enable = true;
    autostart = true;
  };

  preferences = {
    browser = {
      package = pkgs.librewolf;
      desktopFile = "librewolf.desktop";
    };
    editor.package = inputs.nixvim.packages.${system}.default;

    vpn = {
      enable = true;
      disabledIPs = [
        # nixos.wiki gets mad
        "172.67.75.217"
        "104.26.14.206"
        "104.26.15.206"
      ];
      dns = [ "10.2.0.1" ];
      address = [ "10.2.0.2/32" ];
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

  environment.systemPackages = [
    pkgs.microfetch
  ];


}
