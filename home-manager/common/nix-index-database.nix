{ pkgs, ... }:
let
  sources = import ../../npins;
  packages = (import sources.nix-index-database) { inherit pkgs; };
  dummyFlake = {
    packages.${pkgs.stdenv.system} = packages;
  };
  hmModule = (import "${sources.nix-index-database}/home-manager-module.nix") dummyFlake;
in
{
  imports = [ hmModule ];
}
