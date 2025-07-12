{pkgs, ...}: {
  home.packages = with pkgs; [git-crypt];

  programs.git = {
    enable = true;
    userName = "KreconyMakaron";
    userEmail = "55319736+KreconyMakaron@users.noreply.github.com";
  };
}
