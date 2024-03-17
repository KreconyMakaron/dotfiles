{config, ...}: {
  wayland.windowManager.hyprland = {
    settings = {
      general = {
        gaps_in = 6;
        gaps_out = 11;
        border_size = 2;
      };
    };
  };
}
