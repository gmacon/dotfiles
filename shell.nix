let
  sources = import ./npins;
  pkgs = import sources.nixpkgs-stable { };
in
pkgs.mkShell {
  packages = builtins.attrValues {
    inherit (pkgs)
      npins
      nvd
      yq-go
      ;
    agenix = pkgs.callPackage "${sources.agenix}/pkgs/agenix.nix" { };
    colmena = pkgs.callPackage "${sources.colmena}/package.nix" { };
  };
}
