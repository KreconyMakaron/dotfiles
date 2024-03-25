{theme, ...}: {
	programs.zathura = {
		enable = true;

		options = with theme.colors; {
			default-fg = "#${base0}";
			default-bg = base4alpha;

			recolor-lightcolor = "rgba(0, 0, 0, 0)";
			recolor-darkcolor = "#${base0}";

			inputbar-fg = "#${base0}";
			inputbar-bg = base4alpha;

			statusbar-fg = "#${base0}";
			statusbar-bg = base4alpha;

			index-fg = "#${base0}";
			index-bg = "#${zathura-highlight-active}";

			index-active-fg = base4alpha;
			index-active-bg = zathura-highlight-active;

			highlight-color = zathura-highlight;
      highlight-active-color = zathura-highlight-active;
			highlight-fg = base4alpha;

			smooth-scroll = true;
		};
	};
}
