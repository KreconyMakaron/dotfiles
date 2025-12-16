{
  lib,
  config,
  user,
  pkgs,
  ...
}:
with lib; let
  cfg = config.gaming;
in {
  options.gaming = {
    steam.enable = mkEnableOption "Enables steam";
    minecraft = {
      enable = mkEnableOption "Enables minecraft (polymc)";
      package = mkOption {
        type = types.package;
        default = pkgs.polymc;
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.minecraft.enable {home-manager.users.${user}.home.packages = [cfg.minecraft.package];})
    (mkIf cfg.steam.enable {
      programs.steam.enable = true;
      preferences.nix.unfreePackages = [
        "steam"
        "steam-unwrapped"
      ];
    })
  ];
}
