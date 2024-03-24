{
	config,
	lib,
	modulesPath,
	...
}: {
	imports = [
		(modulesPath + "/installer/scan/not-detected.nix")
	];

	boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod"];
	boot.initrd.kernelModules = [];
	boot.kernelModules = ["kvm-intel"];
	boot.extraModulePackages = [];

	fileSystems."/" = {
		device = "/dev/disk/by-uuid/afdc9e20-6a06-4691-9ac3-2b38b91c8115";
		fsType = "ext4";
	};

	fileSystems."/boot" = {
		device = "/dev/disk/by-uuid/0EC6-F363";
		fsType = "vfat";
	};

	swapDevices = [
		{device = "/dev/disk/by-uuid/c3a278ab-9f61-492f-b94b-96a4edef300c";}
	];
	networking.useDHCP = lib.mkDefault true;
	nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
