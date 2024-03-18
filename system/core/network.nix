{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    speedtest-cli
  ];
  networking = {
    networkmanager = {
      enable = true;
    };
  };
}
