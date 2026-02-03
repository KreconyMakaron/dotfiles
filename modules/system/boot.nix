{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot = {
    loader = {
      systemd-boot = {
        consoleMode = "auto";
        enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      verbose = false;
      systemd.enable = true;
    };
    kernelParams = [
      "logo.nologo"
      "fbcon=nodefer"
      "bgrt_disable"
      "vt.global_cursor_default=0"
      "quiet"
      "systemd.show_status=false"
      "rd.udev.log_level=3"
      "splash"
    ];
    consoleLogLevel = 3;
  };

  environment.systemPackages = [ pkgs.tuigreet ];
  services.greetd = {
    enable = !config.services.displayManager.gdm.enable;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
