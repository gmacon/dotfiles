{ pkgs, ... }:
{
  nix.package = pkgs.lix;
  nix.settings = {
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
    substituters = [
      "https://cache.nixos.org/"
      "https://cache.garnix.io"
    ];
  };
}
