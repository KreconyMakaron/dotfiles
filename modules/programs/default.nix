{
  mkImports,
  config,
  lib,
  user,
  ...
}:
with lib; let
  cfg = config.settings;
in {
  imports = mkImports [
    ./git.nix
    ./firefly.nix
    ./foot.nix
    ./sql.nix
    ./vscode.nix
  ];

  options.settings.userPackages = mkOption {
    type = types.listOf types.package;
    default = [];
    description = ''
      Packages to be installed for the user
    '';
  };

  config = {
    home-manager.users.${user}.home.packages = cfg.userPackages;
  };
}
