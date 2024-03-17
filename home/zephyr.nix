{pkgs, ...}: {
  home.stateVersion = "22.11";

  imports = [
    ../modules/cli
    ../modules/rice
  ];

  home.packages = with pkgs; [
    firefox-devedition-unwrapped
  ];
}
