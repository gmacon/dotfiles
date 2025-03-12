{ sources, ... }:
{
  nix = {
    registry.nixpkgs.to = {
      type = "path";
      path = sources.nixpkgs-stable;
    };
  };
}
