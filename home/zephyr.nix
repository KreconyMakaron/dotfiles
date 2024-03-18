{pkgs, ...}: {
  home.stateVersion = "22.11";

  imports = [
    ../modules/cli
    ../modules/rice
  ];

  home.packages = with pkgs; [
    firefox-devedition-unwrapped
    sof-firmware
    alsa-utils

    # zaphyr has an autistic audio card :) i need to manually enable these
    # idk how to else handle this other than putting in hyprlands exec-once
    # because using runCommand or runCommandLocal gives the error that sound
    # card 0 doesnt exist :(
    (writeShellScriptBin "alsa-fixes-script" ''
      amixer -c 0 cset 'numid=69' 1
         amixer -c 0 cset 'numid=70' 1
         amixer -c 0 cset 'numid=71' 1
         amixer -c 0 cset 'numid=72' 1
    '')
  ];
}
