pkgs: {
  everforest = {
    wallpaper = pkgs.fetchurl {
      url = "https://github.com/Apeiros-46B/everforest-walls/blob/main/nature/fog_forest_alt_1.png?raw=true";
      sha256 = "sha256-IeQzvScaS107R+639JzH/Jaxo4Vp0G+wpAm3ufoYHbY=";
    };
    scheme = "${pkgs.base16-schemes}/share/themes/everforest-dark-hard.yaml";
    polarity = "dark";
    cursor = {
      normal = {
        size = 24;
        name = "Bibata-Modern-Classic";
        package = pkgs.runCommand "moveUp" {} ''
          mkdir -p $out/share/icons
          ln -s ${pkgs.fetchzip {
            url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v2.0.6/Bibata-Modern-Classic.tar.xz";
            hash = "sha256-jpEuovyLr9HBDsShJo1efRxd21Fxi7HIjXtPJmLQaCU=";
          }} $out/share/icons/Bibata-Modern-Classic
        '';
      };
      hypr = {
        size = 24;
        name = "HyprBibataModernClassicSVG";
        package = pkgs.fetchzip {
          url = "https://cdn.discordapp.com/attachments/1216066899729977435/1216076659149504643/HyprBibataModernClassicSVG.tar.gz?ex=66084d25&is=65f5d825&hm=6430e39b34b09b70884de44d6b961904b33c4c8e1d6b0c657eda5cb9ef6ca3a7&";
          hash = "sha256-8BkQuBVrV/QAy7whD3zQPFwJKXJ7YgLdDcqFDg/zJQA=";
        };
      };
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
