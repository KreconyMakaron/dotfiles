{
	config,
	pkgs,
	...
}: {
	programs.zsh.enable = true;
	users = {
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
