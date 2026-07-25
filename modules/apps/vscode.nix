{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.apps.vscode;
in
{
  options.apps.vscode.enable = mkEnableOption "enables vscode";

  config = mkIf cfg.enable {
    hm.programs.vscode = {
      enable = lib.mkDefault true;
      profiles.default.userSettings = {
        "security.workspace.trust.enabled" = false;
      };
    };

    core.nix.unfreePackages = [
      "vscode"
    ];
  };
}
