{lib, config, ...}: with lib; let
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
  };

  config = {
    assertions = [
      { assertion = cfg.user != "";
        message = "A username must be set";}
    ];
  };
}
