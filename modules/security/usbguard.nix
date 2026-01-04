{
  pkgs,
  lib,
  config,
  user,
  ...
}:
with lib; let
  cfg = config.hardening.usbguard;
in {
  options.hardening.usbguard.enable = mkEnableOption "enables usbguard";

  # https://saylesss88.github.io/nix/hardening_NixOS.html#usb-port-protection
  config = mkIf cfg.enable {
    services.usbguard = {
      enable = true;
      IPCAllowedUsers = ["root" "${user}"];
      presentDevicePolicy = "allow";
      rules = ''
        # allow `only` devices with mass storage interfaces (USB Mass Storage)
        allow with-interface equals { 08:*:* }
        # allow mice and keyboards
        # allow with-interface equals { 03:*:* }

        # Reject devices with suspicious combination of interfaces
        reject with-interface all-of { 08:*:* 03:00:* }
        reject with-interface all-of { 08:*:* 03:01:* }
        reject with-interface all-of { 08:*:* e0:*:* }
        reject with-interface all-of { 08:*:* 02:*:* }
      '';

      dbus.enable = mkDefault config.services.dbus.enable;
    };

    environment.systemPackages = with pkgs; [usbguard usbguard-notifier];
  };
}
