{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.preferences;
  cfgMime = cfg.mimeApps;
in
{
  options.preferences.mimeApps = {
    enable = lib.custom.mkBoolOption "enables mime-apps things" true;
    addUserPackagesToAddedAssociations = lib.custom.mkBoolOption "adds all packages defined in settings.packages to the added associations" true;
  };

  config =
    let
      defaultPkgs = [
        cfg.browser.package
        cfg.pdf.package
        cfg.image.package
        cfg.audio.package
        cfg.video.package
        cfg.terminal.package
        cfg.editor.package
      ]
      ++ (optionals (cfg.secondaryBrowser.package != null) [ cfg.secondaryBrowser.package ]);
    in
    mkMerge [
      (mkIf cfgMime.enable {
        hm.xdg.mimeApps = {
          enable = true;
          defaultApplicationPackages = defaultPkgs;
        };
      })
      (mkIf (cfgMime.enable && cfgMime.addUserPackagesToAddedAssociations) {
        hm.xdg.mimeApps.enable = mkForce false;

        # adapted from https://github.com/nix-community/home-manager/blob/a4d410db95a6416d1008049330bd86b85b5db45a/modules/misc/xdg/mime-apps.nix

        hm.xdg.configFile."mimeapps.list".source =
          let
            baseFile = (pkgs.formats.ini { }).generate "mimeapps.list" {
              "Added Associations" = { };
              "Removed Associations" = { };
              "Default Applications" = { };
            };

            mergedFile =
              pkgs.runCommand "mimeapps.list"
                {
                  inherit defaultPkgs;
                  userPkgs = config.settings.userPackages;
                }
                ''
                  export PATH=$PATH:${pkgs.crudini}/bin

                  function mergeEntry() {
                  	local mime="$1"
                  	local name="$2"
                  	local existing

                  	existing="$(crudini --get $out 'Default Applications' "$mime" 2>/dev/null || true)"
                  	local value="$existing''${existing:+;}''$name"
                  	crudini --ini-options=nospace --inplace --set $out 'Default Applications' "$mime" "$value"
                  }

                  function addEntry() {
                  	local mime="$1"
                  	local desktop="$2"

                  	local existing
                  	existing="$(crudini --get "$out" "Added Associations" "$mime" 2>/dev/null || true)"

                  	# Don't add duplicates per mimeType
                  	case ";$existing;" in
                  		*";$desktop;"*)
                  		return
                  		;;
                  	esac

                  	if [ -n "$existing" ]; then
                  		existing="$existing;$desktop"
                  	else
                  		existing="$desktop"
                  	fi

                  	crudini --ini-options=nospace --inplace --set "$out" "Added Associations" "$mime" "$existing"
                  }

                  install -m644 ${baseFile} $out

                  processPackages() {
                  	local callback="$1"
                  	shift

                  	for p in "$@"; do
                  		[ -d "$p/share/applications" ] || continue

                  		for path in "$p"/share/applications/*.desktop; do
                  			[ -f "$path" ] || continue

                  			name="''${path##*/}"
                  			mimes=$(crudini --get "$path" 'Desktop Entry' MimeType 2>/dev/null || true)

                  			for mime in ''${mimes//;/ }; do
                  				[ -n "$mime" ] || continue
                  				"$callback" "$mime" "$name"
                  			done
                  		done
                  	done
                  }

                  processPackages mergeEntry $defaultPkgs
                  processPackages addEntry $userPkgs;
                '';
          in
          mergedFile;
      })
    ];
}
