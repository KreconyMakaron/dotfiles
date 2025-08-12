{
  importWithStuff,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.style;
in {
  imports = builtins.map importWithStuff [
    ./compositor.nix
    ./binds.nix
    ./style.nix
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
    };

    widgets = {
      ags = {
        enable = mkEnableOption "enables my ags shell";
      };
    };
  };

  config = {
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
      ]
      ++ (workOnWayland [
        [cfg.widgets.ags.enable "ags shell"]
        [cfg.desktopEnvironment.Hyprland.enable "Hyprland"]
      ]);
  };
}
