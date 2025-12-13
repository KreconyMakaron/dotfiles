{
  pkgs,
  user,
  ...
}: {
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  environment.systemPackages = with pkgs; [
    libjack2
    jack2
    qjackctl
    pavucontrol
    libjack2
    jack2
    qjackctl
    jack_capture
  ];

  users.users.${user}.extraGroups = ["audio"];

  musnix = {
    enable = true;
    soundcardPciId = "00:1f.3";
  };

  services.pulseaudio.enable = false;
  environment.variables.PIPEWIRE_RUNTIME_DIR = "/run/user/1000";
}
