{
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
    lazygit
  ];

  home-manager.users.${user}.programs.git = {
    enable = true;
    userName = "KreconyMakaron";
    userEmail = "55319736+KreconyMakaron@users.noreply.github.com";
  };
}
