{
  pkgs,
  lib,
  config,
  user,
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

    home-manager.users.${user}.systemd.user.services.protonvpn-autostart = {
      Unit = {
        Description = "Starts ProtonVPN";
        Requires = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Service = {
        RemainAfterExit = true;
        Type = "simple";
        ExecStart = [
          "${lib.getExe' pkgs.protonvpn-gui "protonvpn-app"}"
        ];
      };
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
