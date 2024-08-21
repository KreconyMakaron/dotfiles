{
	pkgs,
	...
}: let
	browser = ["firefox-devedition.desktop"];

	associations = {
		"text/html" = browser;
		"x-scheme-handler/http" = browser;
		"x-scheme-handler/https" = browser;
		"x-scheme-handler/ftp" = browser;
		"x-scheme-handler/about" = browser;
		"x-scheme-handler/unknown" = browser;
		"application/x-extension-htm" = browser;
		"application/x-extension-html" = browser;
		"application/x-extension-shtml" = browser;
		"application/xhtml+xml" = browser;
		"application/x-extension-xhtml" = browser;
		"application/x-extension-xht" = browser;
		"application/json" = browser;
		"application/pdf" = ["org.pwmt.zathura.desktop"];

		"audio/*" = ["mpv.desktop"];
		"video/*" = ["mpv.dekstop"];
		"image/*" = ["imv.desktop"];
	};
in {
	home.packages = with pkgs; [xdg-utils];

	xdg = {
		enable = true;

		portal = {
			enable = true;
			config.common.default = "*";
			extraPortals = [
				pkgs.xdg-desktop-portal-gtk
				pkgs.xdg-desktop-portal-hyprland
			];
		};

		userDirs = {
			enable = true;
			download = "$HOME/download";
			documents = "$HOME/docs";
			videos = "$HOME/vids";
			music = "$HOME/music";
			pictures = "$HOME/pics";
			desktop = "$HOME/other";
			publicShare = "$HOME/other";
			templates = "$HOME/other";
		};

		mimeApps = {
			enable = true;
			associations.added = associations;
			defaultApplications = associations;
		};

		desktopEntries = {
			obsidian-diary = {
				name = "Obsidian Diary";
				type = "Application";
				exec = "obsidian \"obsidian://open?vault=diary\"";
				categories = ["Office"];
				comment = "Daily Journaling";
				icon = "obsidian";
				mimeType = ["x-scheme-handler/obsidian"];
			};

			obsidian-notes = {
				name = "Obsidian Notes";
				type = "Application";
				exec = "obsidian \"obsidian://open?vault=TheAll\"";
				categories = ["Office"];
				comment = "School Notes";
				icon = "obsidian";
				mimeType = ["x-scheme-handler/obsidian"];
			};
		};
	};
}
