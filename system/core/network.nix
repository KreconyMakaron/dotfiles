{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    speedtest-cli
  ];
  networking = {
    networkmanager = {
      enable = true;
    };
  };
}
