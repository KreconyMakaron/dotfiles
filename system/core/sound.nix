{...}: {
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		audio.enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		wireplumber.enable = true;
		pulse.enable = true;
	};

	sound.enable = false;
	hardware = {
		pulseaudio.enable = false;
	};

	environment = {
		variables = {
			PIPEWIRE_RUNTIME_DIR = "/run/user/1000";
		};
	};
}
