{importWithStuff, ...}: {
  imports = builtins.map importWithStuff [
    ./compositor.nix
    ./binds.nix
    ./style.nix
  ];
}
