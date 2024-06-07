{ lib
, stdenvNoCC
, bash
, feh
, graphviz
, python3
}: stdenvNoCC.mkDerivation {
  pname = "flake-graph";
  version = "1.0.0";
  src = lib.fileset.toSource {
    root = ./.;
    fileset = ./flake_graph.py;
  };
  buildInputs = [ python3 ];
  buildPhase = ''
    runHook preBuild
    cat >flake-graph <<EOF
    #!${lib.getExe bash}
    $out/bin/flake_graph.py | ${lib.getExe' graphviz "dot"} -Tpng | ${lib.getExe feh} -
    EOF
    chmod +x flake-graph
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -D -t $out/bin flake-graph flake_graph.py
    runHook postInstall
  '';
}
