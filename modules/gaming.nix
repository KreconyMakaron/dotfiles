{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.gaming;
in
{
  options.gaming = {
    steam.enable = mkEnableOption "Enables steam";
    minecraft = {
      enable = mkEnableOption "Enables minecraft (polymc)";
      package = mkOption {
        type = types.package;
        default = pkgs.polymc;
      };
    };
    lutris.enable = mkEnableOption "enables lutris";
  };

  config = mkMerge [
    (mkIf cfg.minecraft.enable {
      nixpkgs.overlays = [ inputs.polymc.overlay ];
      settings.userPackages = [ cfg.minecraft.package ];
    })
    (mkIf cfg.steam.enable {
      programs.gamemode.enable = true;

      programs.steam = {
        enable = true;

        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];

        extraPackages = with pkgs; [
          mangohud
          gamemode
        ];
      };
      core.nix.unfreePackages = [
        "steam"
        "steam-unwrapped"
      ];
    })
    (mkIf cfg.lutris.enable {
      hm.programs.lutris = {
        enable = true;
      };
    })
  ];
}
