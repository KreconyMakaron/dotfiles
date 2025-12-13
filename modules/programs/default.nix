{importWithStuff, ...}: {
  imports = builtins.map importWithStuff [
    ./git.nix
    ./firefly.nix
    ./foot.nix
    ./sql.nix
  ];
}
