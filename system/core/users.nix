{pkgs, ...}: {
	programs.zsh.enable = true;
	users = {
		defaultUserShell = pkgs.zsh;
		users = {
			krecony = {
				isNormalUser = true;
				description = "krecony";
				extraGroups = [
					"networkmanager"
					"wheel"
				];
				shell = pkgs.zsh;
				#hashedPasswordFile =
			};
		};
	};
}
