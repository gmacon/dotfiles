let
  sources = import ./npins;
  nixpkgsModule = import ./nixos/nixpkgs.nix { inherit sources; };
in
import sources.nixpkgs nixpkgsModule.nixpkgs
