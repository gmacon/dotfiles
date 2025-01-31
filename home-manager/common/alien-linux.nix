{ sources, ... }:
{
  nix = {
    registry.nixpkgs.flake = sources.nixpkgs-stable;
  };
}
