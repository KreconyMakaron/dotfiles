{
  config,
  user,
  pkgs,
  ...
}: {
  hm.programs.foot = {
    enable = config.preferences.terminal.package == pkgs.foot;
    server.enable = false;
    settings = {
      main.pad = "8x8 center";
      mouse.hide-when-typing = "yes";
      #colors.scrollback-indicator = "${foot-bg} ${foot-bg}";
    };
  };
}
