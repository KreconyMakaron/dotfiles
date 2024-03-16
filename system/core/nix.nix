{
	config,
	pkgs,
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
			allowUnFree = true;
			allowBroken = true;
			permittedInsecurePackages = [
				"nix-2.16.2"
			];
		};
	};

	documentation = {
		enable = true;
		doc.enable = false;
		man.enable = true;
		dev.enable = false;
	};

	nix = {
		gc = {
			automatic = true;
			dates = "daily";
			options = "--delete older than 5d";
		};

		extraOptions = ''
			experimental-features = nix-command flakes
			keep-outputs = true
			warn-dirty = false
			keep-derivations = true
		'';

		settings = {
			auto-optimise-store = true;
			substituters = [
				"https://cache.nixos.org"
				"https://nix-community.cachix.org"
			];
			experimental-features = [ "nix-command" "flakes" ];
		};
	};
  system.stateVersion = "24.05";
	system.autoUpgrade.enable = false; #change later
}
