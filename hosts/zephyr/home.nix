{pkgs, ...}: {
  home.stateVersion = "22.11";

  imports = [
    ../../modules/cli
    ../../modules/rice
    ../../modules/misc
    ../../modules/fixes/alsa-fixes.nix # huawei laptop goes brrr
  ];
}
