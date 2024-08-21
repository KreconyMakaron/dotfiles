{pkgs, ...}: {
	programs.zsh.enable = true;
	users = {
		defaultUserShell = pkgs.zsh;
		users = {
			krecony = {
				isNormalUser = true;
				description = "the man the myth the legend";
				extraGroups = [
					"networkmanager"
					"wheel"
				];
				shell = pkgs.zsh;
			};
		};
	};
}
