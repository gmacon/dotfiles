{ pkgs, sources, ... }:
{
  nixpkgs.flake.source = sources.nixpkgs-stable;

  # Workaround for CVE-2025-32438
  # https://github.com/NixOS/nixpkgs/security/advisories/GHSA-m7pq-h9p4-8rr4
  systemd.shutdownRamfs.enable = false;

  security.sudo-rs.enable = true;

  nix = {
    package = pkgs.lix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      keep-outputs = true;
      keep-derivations = true;
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      randomizedDelaySec = "1h";
      options = "--delete-older-than 30d";
    };
  };
}
