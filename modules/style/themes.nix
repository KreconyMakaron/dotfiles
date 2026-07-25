pkgs:
let
  everforest-wallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Apeiros-46B/everforest-walls/refs/heads/main/nature/fog_forest_alt_1.png";
    sha256 = "sha256-IeQzvScaS107R+639JzH/Jaxo4Vp0G+wpAm3ufoYHbY=";
  };

  bibata-modern-classic = pkgs.runCommand "moveUp" { } ''
    mkdir -p $out/share/icons
    ln -s ${
      pkgs.fetchzip {
        url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz";
        hash = "sha256-jpEuovyLr9HBDsShJo1efRxd21Fxi7HIjXtPJmLQaCU=";
      }
    } $out/share/icons/Bibata-Modern-Classic
  '';
in
{
  everforest = {
    wallpaper = everforest-wallpaper;
    scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    polarity = "dark";
    cursor = {
      size = 24;
      name = "Bibata-Modern-Classic";
      package = bibata-modern-classic;
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
