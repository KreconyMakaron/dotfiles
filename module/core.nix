{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.core;
in {
  options.core = {
    user = mkOption {
      type = types.str;
      default = "";
      description = ''
        The username used throughout the system
        for example for home-manager
      '';
    };
    flakePath = mkOption {
      type = types.str;
      default = "/etc/nixos";
      description = "path to your nixos config";
    };
    shell = mkOption {
      type = types.enum [
        "zsh"
      ];
      default = "zsh";
      description = "system shell";
    };
  };

  config = let
    shellPackage =
      if cfg.shell == "zsh"
      then pkgs.zsh
      else pkgs.bash;
  in {
    assertions = [
      {
        assertion = cfg.user != "";
        message = "A username must be set";
      }
    ];

    users = {
      defaultUserShell = shellPackage;
      users = {
        ${cfg.user} = {
          isNormalUser = true;
          useDefaultShell = true;
          extraGroups = [
            "networkmanager"
            "wheel"
            "bluetooth"
          ];
        };
      };
    };

  };
}
