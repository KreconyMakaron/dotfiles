{pkgs, ...}: {
  imports = [
    ./zsh
    ./tools.nix
    ./git.nix
    ./neovim.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    hyperfine
    jq
    unzip
    qrcp
    alejandra
    (
      writeShellScriptBin
      "rebuild"
      ''
        set -e
        genfile=/tmp/nixos-generations
        pushd ~/.dotfiles &>/dev/null
        alejandra .
        git add .
        echo "NixOS Rebuilding..."
        sudo nixos-rebuild switch --flake . &>nixos-switch.log || (cat nixos-switch.log | rg error && false)
        nixos-rebuild list-generations &> $genfile
        git commit -am "Generation $(rg current $genfile | awk '{ print $1 }')"
        rm $genfile
        popd &>/dev/null
      ''
    )
  ];
}
