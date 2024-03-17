{
  config,
  lib,
  pkgs,
  ...
}: let
  mod = "SUPER";
  modshift = "SUPER SHIFT";
in {
  wayland.windowManager.hyprland.settings = {
    bind =
      [
        "${mod},RETURN,exec,kitty"
        "${mod},P,exec,kitty"
        "${mod},Q,killactive"

        "${mod},H,movefocus,l"
        "${mod},L,movefocus,r"
        "${mod},K,movefocus,u"
        "${mod},J,movefocus,d"

        "${mod},D,exec,${pkgs.wofi}/bin/wofi --show drun"
        "${mod},V,togglefloating,"
        "${mod},F,fullscreen,"
        "${mod},W,exec,${pkgs.firefox-devedition-unwrapped}/bin/firefox"
      ]
      ++ (
        builtins.concatLists (builtins.genList (
            x: let
              ws = let
                c = (x + 1) / 10;
              in
                builtins.toString (x + 1 - (c * 10));
            in [
              "${mod}, ${ws}, workspace, ${toString (x + 1)}"
              "${modshift}, ${ws}, movetoworkspace, ${toString (x + 1)}"
            ]
          )
          10)
      );

    bindm = [
      "${mod},mouse:272,movewindow"
      "${mod},mouse:273,resizewindow"
    ];
    binde = [
      ",XF86MonBrightnessUp,exec,brightnessctl set +10%"
      ",XF86MonBrightnessDown,exec,brightnessctl set 10%-"
    ];
  };
}
