{...}: {
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "workspace special silent,^(pavucontrol)$"
      "float,^(pavucontrol)$"
      "center,^(pavucontrol)$"
      "size 50% 50%,^(pavucontrol)$"
      "dimaround,^(pavucontrol)$"
    ];
  };
}
