{
  sources ? import ./npins,
  nodes,
  ...
}:
let
  pkgs = import sources.nixpkgs { };
in
pkgs.symlinkJoin {
  name = "merged";
  paths = (
    builtins.attrValues (builtins.mapAttrs (name: node: node.config.system.build.toplevel) nodes)
  );
}
