{ pkgs, ... }:
{
  nix.package = pkgs.lix;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "1h";
    options = "--delete-older-than 30d";
  };
}
