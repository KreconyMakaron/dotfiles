{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.settings.boot;
  grubModules = [
    "part_gpt"
    "part_msdos"
    "fat"
    "btrfs"
    "cryptodisk"
    "luks"
    "pbkdf2"
    "gcry_sha256"
    "gcry_sha512"
    "normal"
    "configfile"
    "linux"
    "efi_gop"
    "efi_uga"
    "gfxterm"
    "gfxterm_background"
    "gettext"
  ];
  moduleString = concatStringsSep " " grubModules;
in
{
  options.settings.boot = {
    diskEncryption = mkEnableOption "encrypts the disk and makes UEFI encrypt it";
    quietBoot = mkEnableOption "adds kernelParams that reduce logging to the screen";
  };

  config = {
    boot = {
      loader = {
        systemd-boot = {
          enable = mkDefault true;
          consoleMode = mkDefault "auto";
        };
        grub.enable = mkDefault false;
      };
      initrd = {
        verbose = mkDefault false;
        systemd.enable = mkDefault true;
      };
      kernelParams = mkIf cfg.quietBoot [
        "logo.nologo"
        "fbcon=nodefer"
        "bgrt_disable"
        "vt.global_cursor_default=0"
        "quiet"
        "systemd.show_status=false"
        "rd.udev.log_level=3"
        "splash"
      ];
      consoleLogLevel = if cfg.quietBoot then 3 else 4;
    };

    environment.systemPackages = [ pkgs.tuigreet ];
    services.greetd = {
      enable = !config.services.displayManager.gdm.enable;
      settings = {
        default_session = {
          command = "${getExe pkgs.greetd.tuigreet} --time --cmd Hyprland";
          user = "greeter";
        };
      };
    };
  }
  // mkIf cfg.diskEncryption {
    boot.loader = {
      grub = {
        enable = mkForce true;
        device = mkForce "nodev";
        efiSupport = mkForce true;
        enableCryptodisk = mkForce true;
        extraGrubInstallArgs = mkForce [ "--modules=${moduleString}" ];
      };
      systemd-boot.enable = mkForce false;
      efi = {
        canTouchEfiVariables = mkForce true;
        efiSysMountPoint = mkDefault "/efi";
      };
    };
  };
}
