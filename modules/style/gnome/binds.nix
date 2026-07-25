{ lib, config, ... }:
with lib;
{
  "org/gnome/desktop/wm/keybindings" = {
    close = [ "<Super>q" ];
    # grouped by app
    switch-applications = [ "<Super>Tab" ];
    switch-applications-backward = [ "<Shift><Super>Tab" ];
    # not grouped
    switch-windows = [ "<Alt>Tab" ];
    switch-windows-backward = [ "<Shift><Alt>Tab" ];
  };
  # cycles through everything, not just current workspace
  "org/gnome/shell/window-switcher".current-workspace-only = false;
  "org/gnome/settings-daemon/plugins/media-keys" = {
    custom-keybindings = [
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
    ];
    home = [ "<Shift><Super>e" ];
    screensaver = [ "<Control><Shift>l" ];
    www = [ "<Super>w" ];
  };
  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" =
    mkIf (config.preferences.secondaryBrowser != null)
      {
        binding = "<Shift><Super>w";
        command = getExe config.preferences.secondaryBrowser;
        name = "Launch second browser";
      };
  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
    binding = "<Super>Return";
    command = getExe config.preferences.terminal;
    name = "Launch terminal";
  };
  "org/gnome/shell/extensions/tilingshell" = {
    focus-window-down = "<Super>j";
    focus-window-left = "<Super>h";
    focus-window-right = "<Super>l";
    focus-window-up = "<Super>k";
  };
  "org/gnome/shell/extensions/caffeine" = {
    toggle-shortcut = [ "<Shift><Super>c" ];
  };
  "org/gnome/shell/extensions/paperwm/keybindings" = {
    live-alt-tab = [ "" ];
    live-alt-tab-backward = [ "" ];
    move-down = [
      "<Shift><Super>j"
      "<Shift><Super>Down"
    ];
    move-left = [
      "<Shift><Super>h"
      "<Shift><Super>Left"
    ];
    move-right = [
      "<Shift><Super>l"
      "<Shift><Super>Right"
    ];
    move-up = [
      "<Shift><Super>k"
      "<Shift><Super>Up"
    ];
    new-window = [ "<Super>n" ];
    switch-down = [
      "<Super>Down"
      "<Super>j"
    ];
    switch-focus-mode = [ "" ];
    switch-left = [
      "<Super>Left"
      "<Super>h"
    ];
    switch-open-window-position = [ "<Shift><Super>a" ];
    switch-right = [
      "<Super>Right"
      "<Super>l"
    ];
    switch-up = [
      "<Super>Up"
      "<Super>k"
    ];
    toggle-scratch = [ "<Control><Super>x" ];
    toggle-scratch-layer = [ "<Control><Super>z" ];
  };
}
