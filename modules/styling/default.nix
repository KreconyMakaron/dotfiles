{
  importWithStuff,
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.style;
in {
  imports = builtins.map importWithStuff [
    ./compositor.nix
    ./binds.nix
    ./style.nix
    ./gnome.nix
  ];

  options.style = {
    displayServer = {
      wayland = {
        enable = mkEnableOption "enables wayland (mutually exclusive with x11)";
        default = true;
      };
      x11 = {
        enable = mkEnableOption "enables x11 (mutually exclusive with wayland)";
        default = false;
      };
    };

    desktopEnvironment = {
      Hyprland = {
        enable = mkEnableOption "enables Hyprland";
        default = true;
      };
      gnome = {
        enable = mkEnableOption "enables the gnome desktop environment";
        default = false;
      };
    };

    widgets = {
      ags = {
        enable = mkEnableOption "enables my ags shell";
      };
    };
  };

  config = {
    home-manager.users.${user}.services.ags = {
      inherit (cfg.widgets.ags) enable;
      hyprlandIntegration = {
        inherit (cfg.desktop.Hyprland) enable;
        autostart.enable = true;
        keybinds.enable = true;
      };
    };

    programs.xwayland.enable = cfg.displayServer.wayland.enable;

    assertions = let
      workOnWayland = list: let
        mkAssertion = attr: opt: {
          assertion = !(attr && cfg.displayServer.x11.enable);
          message = "${opt} only works on wayland!";
        };
      in
        map (x: mkAssertion (elemAt x 0) (elemAt x 1)) list;
    in
      [
        {
          assertion = !(cfg.displayServer.wayland.enable && cfg.displayServer.x11.enable);
          message = "wayland and x11 are mutually exclusive";
        }
        {
          assertion = !(cfg.desktopEnvironment.Hyprland.enable && cfg.desktopEnvironment.gnome.enable);
          message = "only one desktop environment can be enabled at a time";
        }
      ]
      ++ (workOnWayland [
        [cfg.widgets.ags.enable "ags shell"]
        [cfg.desktopEnvironment.Hyprland.enable "Hyprland"]
      ]);
  };
}
