{
  config,
  pkgs,
  ...
}:
{
  hm.programs.foot = {
    enable = config.preferences.terminal == pkgs.foot && (config.style.displayServer != "headless");
    server.enable = false;
    settings = {
      main.pad = "8x8 center";
      mouse.hide-when-typing = "yes";
      #colors.scrollback-indicator = "${foot-bg} ${foot-bg}";
    };
  };
}
