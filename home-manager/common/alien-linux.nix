{ sources, ... }:
{
  nix = {
    registry.nixpkgs.to = {
      type = "path";
      path = sources.nixpkgs-stable;
    };
  };
  home.sessionVariables = {
    NIX_PATH = "nixpkgs=${sources.nixpkgs-stable}:home-manager=${sources.home-manager}";
  };
}
