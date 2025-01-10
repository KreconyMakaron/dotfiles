{pkgs, ...}: {
	home.packages = with pkgs; [ git-crypt ];

	programs.git = {
		enable = true;
		userName = "KreconyMakaron";
		userEmail = "github.driven504@passinbox.com";
	};
}
