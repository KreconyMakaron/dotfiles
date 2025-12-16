{importWithStuff, ...}: {
  imports = builtins.map importWithStuff [
    ./system.nix
    ./nix.nix
    ./sound.nix
    ./boot.nix
    ./bluetooth.nix
    ./printing.nix
    ./sleep.nix
    ./intel.nix
    ./wayland.nix
  ];
}
