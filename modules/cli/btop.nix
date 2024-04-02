{pkgs, ...}: {
	programs.btop = {
		enable = true;
		settings = {
			color_theme = "catppuccin_frappe";
			theme_background = false;
			update_ms = 1000;
		};
	};

	xdg.configFile."btop/themes/catppuccin_frappe.theme".source = pkgs.fetchFromGitHub {
		owner = "catppuccin";
		repo = "btop";
		rev = "b5004e229e9a444f25e2ec126d74fe1527d7ec01";
		hash = "sha256-7m+m1HhcC9fK8MzYcndTexGx6gpV0seEQSYFLYpGjFQ=";
	} + "/themes/catppuccin_frappe.theme";
}
