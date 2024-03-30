{
	config,
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
		portal = {
			enable = true;
			config.common.default = "*";
			extraPortals = [
				pkgs.xdg-desktop-portal-gtk
				pkgs.xdg-desktop-portal-hyprland
			];
		};

		enable = true;
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
		mimeApps.enable = true;
		mimeApps.associations.added = associations;
		mimeApps.defaultApplications = associations;
	};

	home.file.".local/share/applications/obsidian-diary.desktop".text = ''
		[Desktop Entry]
		Categories=Office
		Comment=Daily Journaling
		Exec=obsidian "obsidian://open?vault=diary"
		Icon=obsidian
		MimeType=x-scheme-handler/obsidian
		Name=Obsidian Diary
		Type=Application
		Version=1.4
	'';

	home.file.".local/share/applications/obsidian-notes.desktop".text = ''
		[Desktop Entry]
		Categories=Office
		Comment=School Notes
		Exec=obsidian "obsidian://open?vault=TheAll"
		Icon=obsidian
		MimeType=x-scheme-handler/obsidian
		Name=Obsidian Notes
		Type=Application
		Version=1.4
	'';
}
