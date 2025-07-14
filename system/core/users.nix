{pkgs, ...}: {
  programs.zsh.enable = true;
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      krecony = {
        isNormalUser = true;
        extraGroups = [
          "networkmanager"
          "wheel"
          "bluetooth"
        ];
        shell = pkgs.zsh;
      };
    };
  };
}
