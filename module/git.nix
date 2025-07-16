{pkgs, ...}: {
  environment.systemPackages = with pkgs; [git];

  home-manager.users.krecony.programs.git = {
    enable = true;
    userName = "KreconyMakaron";
    userEmail = "55319736+KreconyMakaron@users.noreply.github.com";
  };
}
