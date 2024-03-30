{pkgs, ...}: {
	programs.firefox = {
		enable = true;
		package = pkgs.firefox-devedition;

		profiles.default = {
			isDefault = false;
			id = 0;
		};

		profiles.dev-edition-default = {
			isDefault = true;
			id = 1;
			search = {
				force = true;
				default = "DuckDuckGo";
				privateDefault = "DuckDuckGo";
			};

			userChrome = builtins.readFile (pkgs.fetchFromGitHub {
				owner = "mimipile";
				repo = "firefoxCSS";
				rev = "2a0e6c2ccd424311e527cd6526b12e3acd2c43b5";
				hash = "sha256-r17ykbZUs0xMb/x7gNvkVlBmeFur3CcvZDcNjSD9FDo=";
			} + "/userChrome.css");
			settings = {
				"browser.newtabpage.activity-stream.feeds.topsites" = false;

				# Browser Privacy = Strict
				"privacy.annotate_channels.strict_list.enabled" = true;
				"privacy.fingerprintingProtection" = true;
				"privacy.query_stripping.enabled" = true;
				"privacy.query_stripping.enabled.pbmode" = true;
				"privacy.trackingprotection.emailtracking.enabled" = true;
				"privacy.trackingprotection.enabled" = true;
				"privacy.trackingprotection.socialtracking.enabled" = true;

				"privacy.donottrackheader.enabled" = true;
				"privacy.globalprivacycontrol.enabled" = true;
				"signon.rememberSignons" = false;
				"extensions.formautofill.creditCards.enabled" = false;
				"extensions.formautofill.addresses.enabled" = false;
				"datareporting.healthreport.uploadEnabled" = false;
				"app.shield.optoutstudies.enabled" = false;
				"dom.security.https_only_mode" = true;
				"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
			};
		};

		policies = {
			Preferences = {
				"toolkit.legacyUserProfileCustomizations.stylesheets" = true;
				DefaultDownloadDirectory = "\${home}/download";
				"browser.compactmode.show" = true;
			};
		};
	};
}
