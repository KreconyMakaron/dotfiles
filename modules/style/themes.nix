pkgs:
let
  everforest-wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Apeiros-46B/everforest-walls/refs/heads/main/nature/fog_forest_alt_1.png";
    sha256 = "sha256-IeQzvScaS107R+639JzH/Jaxo4Vp0G+wpAm3ufoYHbY=";
  };
in
{
  everforest = {
    wallpaper = everforest-wallpaper;
    scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    polarity = "dark";
    cursor = {
      size = 24;
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
    autoEnable = true;
    targets = {
      hm = [
        "vim"
        "firefox"
        "neovim"
        "hyprlock"
        "hyprland"
        "starship"
      ];
    };
  };
}
