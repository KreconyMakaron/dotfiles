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
  };

  environment.systemPackages = [
    pkgs.microfetch
  ];
}
