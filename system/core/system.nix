{pkgs, ...}: {
  time = {
    timeZone = "Europe/Warsaw";
    hardwareClockInLocalTime = false;
  };

  i18n = let
    en = "en_GB.UTF-8";
    pl = "pl_PL.UTF-8";
  in {
    defaultLocale = en;
    extraLocaleSettings = {
      LANG = en;
      LC_ADDRESS = pl;
      LC_IDENTIFICATION = pl;
      LC_MEASUREMENT = pl;
      LC_MONETARY = pl;
      LC_NAME = pl;
      LC_NUMERIC = pl;
      LC_PAPER = pl;
      LC_TELEPHONE = pl;
      LC_TIME = pl;
    };
  };

  environment = {
    variables = {
      EDITOR = "nvim";
      BROWSER = "firefox";
    };

    systemPackages = with pkgs; [
      git
      appimage-run
    ];
  };

  # TODO configure appimages

  console.keyMap = "pl2";
}
