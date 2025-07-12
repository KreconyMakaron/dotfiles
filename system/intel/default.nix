{pkgs, ...}: {
  environment.systemPackages = with pkgs; [mesa];

  boot = {
    kernelModules = ["i915"];
    kernelParams = ["i915.fastboot=1"];
  };

  hardware.opentabletdriver.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-ocl
      intel-vaapi-driver
    ];
  };
}
