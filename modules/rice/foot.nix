{theme, ...}: {
	programs.foot = {
		enable = true;
		server.enable = false;
		settings = {
			main = {
				pad = "8x8 center";
			};
			# 	colors.scrollback-indicator = "${foot-bg} ${foot-bg}";
			mouse = {
				hide-when-typing = "yes";
			};
		};
	};
}
