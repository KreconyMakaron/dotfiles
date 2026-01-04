{
  config,
  lib,
  importWithStuff,
  ...
}:
with lib; let
  cfg = config.hardening;
in {
  options.hardening = {
    disableSUIDs = mkOption {
      type = types.bool;
      default = false;
      description = ''
        disables SUID on executables that can be used for privelage escalation
      '';
    };
    disableSudo = mkOption {
      type = types.bool;
      default = false;
      description = ''
        disables sudo (use run0 instead)
      '';
    };
  };

  imports = map importWithStuff [
    ./clamav.nix
    ./usbguard.nix
  ];

  config = {
    security = {
      polkit.enable = true;
      sudo.enable = !cfg.disableSudo;
      wrappers = mkIf (!cfg.disableSUIDs) {
        su.setuid = lib.mkForce false;
        sudo.setuid = !cfg.disableSudo;
        sudoedit.setuid = lib.mkForce false;
        sg.setuid = lib.mkForce false;
        fusermount.setuid = lib.mkForce false;
        fusermount3.setuid = lib.mkForce false;
        mount.setuid = lib.mkForce false;
        pkexec.setuid = lib.mkForce false;
        newgrp.setuid = lib.mkForce false;
        newgidmap.setuid = lib.mkForce false;
        newuidmap.setuid = lib.mkForce false;
      };
    };
  };
}
