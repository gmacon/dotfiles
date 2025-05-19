{ sources, ... }:
{
  nix = {
    registry.nixpkgs.to = {
      type = "path";
      path = sources.nixpkgs-stable;
    };
  };

  # Force Nix-built applications to open things through the portal.
  # This makes custom URL schemes work correctly
  # when they are registered by non-Nix applications.
  xdg.portal.xdgOpenUsePortal = true;
}
