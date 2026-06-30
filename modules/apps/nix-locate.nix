{
  lib,
  config,
  inputs,
  ...
}:
with lib;
let
  cfg = config.apps.nix-locate;
in
{
  options.apps.nix-locate.enable = mkEnableOption "enables nix-index-database which allows locating files in nixpkgs";

  imports = [
    inputs.nix-index-database.nixosModules.default
  ];

  config = mkIf cfg.enable {
    programs.nix-index-database.comma.enable = true;
  };
}
