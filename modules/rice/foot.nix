{theme, ...}: {
  programs.foot = {
    enable = true;
    server.enable = false;
    settings = {
      main = {
        font = "monospace:size=8";
        term = "xterm-256color";
        dpi-aware = "1";
        pad = "10x5 center";
      };
      colors = with theme.colors; {
        alpha = 0.75;
        foreground = text;
        background = base;

        regular0 = surface1;
        regular1 = red;
        regular2 = green;
        regular3 = yellow;
        regular4 = blue;
        regular5 = pink;
        regular6 = teal;
        regular7 = subtext1;

        bright0 = surface0;
        bright1 = red;
        bright2 = green;
        bright3 = yellow;
        bright4 = blue;
        bright5 = pink;
        bright6 = teal;
        bright7 = subtext0;
      };
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
