let
  sources = import ./npins;
  pkgs = import sources.nixpkgs-stable { };
in
pkgs.mkShell {
  packages = builtins.attrValues {
    inherit (pkgs)
      colmena
      npins
      nvd
      yq-go
      ;
    agenix = pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" { };
    home-manager = pkgs.callPackage "${sources.home-manager}/home-manager" { };
  };
}
