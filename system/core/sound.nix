{...}: {
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		audio.enable = true;
		wireplumber.enable = true;
		pulse.enable = true;
		alsa = {
			enable = true;
			support32Bit = true;
		};
	};

	hardware.pulseaudio.enable = false;
	environment.variables.PIPEWIRE_RUNTIME_DIR = "/run/user/1000";
}
