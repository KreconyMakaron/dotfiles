{
  pkgs,
  user,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.style;

  # https://github.com/nix-community/stylix/blob/0ba0ffe94cbe20ae739c2aa8cae04cbf900bf56b/stylix/cursor.nix
  cursorOpts = {...}: {
    options = {
      name = mkOption {
        description = "The cursor name within the package.";
        type = types.nullOr types.str;
        default = null;
      };
      package = mkOption {
        description = "Package providing the cursor theme.";
        type = types.nullOr types.package;
        default = null;
      };
      size = mkOption {
        description = "The cursor size.";
        type = types.nullOr types.int;
        default = null;
      };
    };
  };

  themeOpts = {...}: {
    options = {
      autoEnable = mkOption {
        type = types.bool;
        default = false;
      };
      targets = {
        # if autoEnable is true then this list is of disabled targets and vice versa
        hm = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "list of targets to disable/enable for home-manager stylix";
        };
        nix = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "list of targets to disable/enable for nixos stylix";
        };
      };
      cursor = {
        normal = mkOption {
          type = types.nullOr (types.submodule cursorOpts);
          default = null;
        };
        hypr = mkOption {
          type = types.nullOr (types.submodule cursorOpts);
          default = null;
        };
      };

      wallpaper = mkOption {
        type = types.nullOr types.path;
        default = null;
      };

      scheme = mkOption {
        type = with types;
          oneOf [
            path
            lines
            attrs
          ];
        default = null;
      };

      polarity = mkOption {
        type = types.enum [
          "either"
          "light"
          "dark"
        ];
        default = "either";
      };
    };
  };

  themes = import ./themes.nix pkgs;

  m = name: nameValuePair name {enable = !cfg.settings.autoEnable;};
  mkTargets = targets: builtins.listToAttrs (map m targets);
in {
  options.style = {
    theme = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "The theme to be used or a blank slate";
    };
    settings = mkOption {
      type = types.submodule themeOpts;

      # we eval the module to get a themeOpts with all default values
      default =
        (evalModules {
          modules = [themeOpts];
        }).config;
    };
  };

  config = mkMerge [
    (mkIf (cfg.theme != null) {
      style.settings =
        if builtins.hasAttr cfg.theme themes
        then builtins.getAttr cfg.theme themes
        else throw "the theme ${cfg.theme} doesn't exist!";
    })
    {
      stylix = {
        enable = true;
        autoEnable = true;

        image = cfg.settings.wallpaper;
        base16Scheme = cfg.settings.scheme;

        inherit (cfg.settings) polarity;

        cursor = cfg.settings.cursor.normal;

        opacity = {
          terminal = 0.75;
        };

        targets = mkTargets cfg.settings.targets.nix;
      };

      home-manager.users.${user} = let
          hyprcursor = cfg.settings.cursor.hypr;
        in {
        stylix.targets = mkTargets cfg.settings.targets.hm;

        home.file.".local/share/icons/${hyprcursor.name}".source = hyprcursor.package;

        wayland.windowManager.hyprland.settings.env = [
          "HYPRCURSOR_THEME,${hyprcursor.name}"
          "HYPRCURSOR_SIZE,${builtins.toString hyprcursor.size}"
        ];
      };
    }
  ];
}
