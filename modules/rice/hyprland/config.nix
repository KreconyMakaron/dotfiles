{config, ...}: {
  wayland.windowManager.hyprland = {
    settings = {
      general = {
        gaps_in = 2;
        gaps_out = 6;
        border_size = 2;
      };
      monitor = [
        "eDP-1,1920x1080@60,0x0,1.25"
      ];
    };
  };
}
