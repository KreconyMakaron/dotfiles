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
    settings.user = {
      name = "KreconyMakaron";
      email = "55319736+KreconyMakaron@users.noreply.github.com";
    };
  };
}
