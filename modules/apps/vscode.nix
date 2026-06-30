{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.apps.vs-code;
in
{
  options.apps.vs-code.enable = mkEnableOption "enables vscode";

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
