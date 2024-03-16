{
	inputs,
	...
}: {
	imports = [ ./fonts.nix ];
	hardware = {
		opengl.enable = true;
		pulseaudio.enable = false;
	};

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };
}
