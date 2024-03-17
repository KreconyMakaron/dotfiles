{
  # convert rrggbb hex to #rrggbb
  pound = c: "#${c}";

  colors = rec {
    rosewater = "f2d5cf";
    flamingo = "eebebe";
    pink = "f4b8e4";
    mauve = "ca9ee6";
    red = "e78284";
    maroon = "ea999c";
    peach = "ef9f76";
    yellow = "e5c890";
    green = "a6d189";
    teal = "81c8be";
    sky = "99d1db";
    sapphire = "85c1dc";
    blue = "8caaee";
    lavender = "babbf1";

    base0 = "f0f0f0";
    base1 = "e6e6e6";
    base2 = "717172";
    base3 = "404040";
    base4 = "2a2a2a";
    base5 = "212121";
    base6 = "080808";

    ice0 = "c6d0f5";
    ice1 = "b2bbdc";
    ice2 = "9ea6c4";
    ice3 = "8a91ab";
    ice4 = "767c93";
    ice5 = "63687a";
    ice6 = "4f5362";
    ice7 = "3b3e49";
    ice8 = "272931";
    ice9 = "131418";

    text = base0;
    base = ice8;
    subtext0 = ice0;
    subtext1 = ice1;
    surface0 = base5;
    surface1 = base6;
    accent = ice0;
  };

  wallpaper = ./monochrome-city.png;
}
