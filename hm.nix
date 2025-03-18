let
  sources = import ./npins;
  pkgs = import sources.nixpkgs-stable { };
in
pkgs.callPackage "${sources.home-manager}/home-manager" { }
