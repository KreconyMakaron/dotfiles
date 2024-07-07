{...}: {
	programs = {
		eza = {
			enable = true;
			icons = true;
		};

		direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

		bat.enable = true;

		btop = {
			enable = true;
			settings.update_ms = 1000;
		};
	};
}
