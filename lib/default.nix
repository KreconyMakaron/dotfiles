{ inputs, ... }:
builtins
// inputs.nixpkgs.lib.extend (
  _: prev: {
    custom = import ./custom.nix prev;
  }
)
