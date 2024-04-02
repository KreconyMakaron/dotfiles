{pkgs, ...}: {
	environment.systemPackages = with pkgs; [
		mesa
		linux-firmware
		intel-media-driver
	];

	boot = {
		kernelModules = [ "i915" ];
		kernelParams = [ 
			"i915.fastboot=1" 
			"i915.enable_fbc=1"
			"i915.enable_guc=3" #Gen 9.5+ card
		];
	};
}
