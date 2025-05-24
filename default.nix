let
  sources = import ./npins;
  nixpkgs = import sources.nixpkgs;
  nixpkgsModule = import ./nixos/nixpkgs.nix {
    inherit sources;
    lib = nixpkgs.lib;
  };
in
import sources.nixpkgs nixpkgsModule.nixpkgs
