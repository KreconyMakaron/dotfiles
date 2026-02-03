{ mkImports, ... }:
{
  imports = mkImports [
    ./system.nix
    ./nix.nix
    ./sound.nix
    ./boot.nix
    ./bluetooth.nix
    ./sleep.nix
    ./intel.nix
    ./wayland.nix
  ];
}
