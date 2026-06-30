{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.hardening.sops;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.hardening.sops.enable = custom.mkBoolOption "enables sops secret managment" true;

  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = ../../secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "${config.hm.xdg.configHome}/sops/age/keys.txt";

      useSystemdActivation = true;

      secrets = {
        "protonvpn/amsterdam" = { };
        "protonvpn/warsaw" = { };
        "protonvpn/berlin-sc" = { };
        "protonvpn/miami" = { };
      };
    };

    environment.systemPackages = with pkgs; [
      sops
    ];
  };
}
