let
  sources = import ../../npins;
  hmModule = (import "${sources.nix-index-database}/home-manager-module.nix") sources.nix-index-database;
in
{
  imports = [ hmModule ];
}
