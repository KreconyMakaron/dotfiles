{importWithStuff, ...}: {
  imports = builtins.map importWithStuff [
    ./system.nix
    ./nix.nix
    ./sound.nix
    ./boot.nix
    ./steam.nix
    ./bluetooth.nix
    ./printing.nix
    ./sleep.nix
  ];
}
