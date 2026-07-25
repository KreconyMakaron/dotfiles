{
  config,
  lib,
  colors,
  ...
}:
with lib.custom;
with colors;
{
  hm.programs.hyprlock = {
    enable = config.style.desktopEnvironment == "hyprland";

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      background = {
        monitor = "";
        color = hex-to-rgb base00;
      };

      input-field = [
        {
          monitor = "";
          size = "300, 50";
          outline_thickness = 3;
          dots_size = 0.33;
          dots_spacing = 0.15;
          outer_color = hex-to-rgb base00;
          inner_color = hex-to-rgb base00;
          font_color = hex-to-rgb base05;
          fade_on_empty = false;
          dots_center = false;
          placeholder_text = "";
          hide_input = false;
          rounding = 0;
          check_color = hex-to-rgb base00;
          fail_color = hex-to-rgb base08;
          fail_text = "dumbass";
          position = "20, 20";
          halign = "left";
          valign = "bottom";
        }
      ];

      label = [
        {
          monitor = "";
          position = "30, 70";
          text = "$TIME";
          font_size = 50;
          color = hex-to-rgb base05;
          halign = "left";
          valign = "bottom";
        }
        {
          monitor = "";
          text = "cmd[update:5000] echo \"$(cat /sys/class/power_supply/BAT1/capacity)%\"";
          text_align = "right";
          color = hex-to-rgb base05;
          position = "-40, 70";
          halign = "right";
          valign = "bottom";
        }
        {
          monitor = "";
          text = "$LAYOUT";
          text_align = "right";
          color = hex-to-rgb base05;
          position = "-40, 40";
          halign = "right";
          valign = "bottom";
        }
      ];
    };
  };
}
