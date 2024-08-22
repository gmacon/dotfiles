{ pkgs, inputs, ... }:
{
  nix = {
    package = pkgs.nix;
    registry.nixpkgs.flake = inputs.nixpkgs;
  };
}
