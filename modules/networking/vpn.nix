{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.preferences;
in {
  options.preferences = {
    vpn.enable = mkEnableOption "enables the vpn";
  };

  config = mkIf cfg.vpn.enable {
    systemd.services.NetworkManager-wait-online.enable = true;

    environment.systemPackages = with pkgs; [
      wireguard-tools
      protonvpn-gui
    ];
    networking.firewall.checkReversePath = false;
  };
}
