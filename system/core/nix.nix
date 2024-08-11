{
	pkgs,
	inputs,
	...
}: {
	environment = {
		systemPackages = with pkgs; [
			git
			deadnix
		];
	};

	nixpkgs = {
		config = {
			allowBroken = true;
			allowUnfree = true;
			permittedInsecurePackages = [
				"nix-2.16.2"
			];
		};
		overlays = [ inputs.polymc.overlay ];
	};

	documentation = {
		enable = true;
		doc.enable = false;
		man.enable = true;
		dev.enable = false;
	};

	programs.nh = {
    enable = true;
		flake = "/home/krecony/.dotfiles";
    clean = {
			enable = true;
			extraArgs = "--keep-since 5d --keep 3";
		};
  };

	nix = {
		extraOptions = ''
			experimental-features = nix-command flakes
			keep-outputs = true
			warn-dirty = false
			keep-derivations = true
		'';

		settings = {
			auto-optimise-store = true;
			experimental-features = ["nix-command" "flakes"];

      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://nixpkgs-unfree.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      ];
		};
	};
	system.stateVersion = "24.05";
	system.autoUpgrade.enable = false; #change later
}
