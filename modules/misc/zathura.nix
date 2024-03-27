{theme, ...}: {
	programs.zathura = {
		enable = true;

		options = with theme.colors; {
			default-fg = "#${base0}";
			default-bg = zathura-bg;

			recolor-lightcolor = "rgba(0, 0, 0, 0)";
			recolor-darkcolor = "#${base0}";

			inputbar-fg = "#${base0}";
			inputbar-bg = zathura-bg;

			statusbar-fg = "#${base0}";
			statusbar-bg = zathura-bg;

			index-fg = "#${base0}";
			index-bg = zathura-highlight-active;

			index-active-fg = "#${base0}";
			index-active-bg = zathura-highlight;

			highlight-color = zathura-highlight;
      highlight-active-color = zathura-highlight-active;

			completion-fg = "#${base0}";
			completion-bg = zathura-highlight-active;

			completion-group-fg = "#${base0}";
			completion-group-bg = zathura-bg;

			completion-highlight-fg = "#${base0}";
			completion-highlight-bg = zathura-highlight;
		};
	};
}
