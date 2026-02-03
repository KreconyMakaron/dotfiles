{modulesPath, ...}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./settings.nix
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod"];
    initrd.kernelModules = [];
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/86d8a5cf-505b-42d7-afc6-25ce88304ef3";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/552C-D8EA";
      fsType = "vfat";
      options =  [ "uid=0" "gid=0" "fmask=0077" "dmask=0077" ];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/11e20899-809c-4d78-94ee-2a0cc1dd4d8b";}
  ];
}
