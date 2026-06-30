{ config, lib, ... }:
with lib;
let
  cfg = config.net.tailscale;
in
{
  options.net.tailscale.enable = mkEnableOption "Enables tailscale";

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      extraSetFlags = [ "--netfilter-mode=nodivert" ];
      extraDaemonFlags = [ "--no-logs-no-support" ];
    };
  };
}
