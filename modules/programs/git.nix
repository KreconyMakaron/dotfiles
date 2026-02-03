{
  pkgs,
  user,
  ...
}: {
  environment.systemPackages = with pkgs; [
    git
    lazygit
  ];

  hm.programs.git = {
    enable = true;
    settings = {
      user = {
        name = "KreconyMakaron";
        email = "55319736+KreconyMakaron@users.noreply.github.com";
      };
      init.defaultBranch = "main";
    };
  };
}
