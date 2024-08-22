{
  lib,
  stdenvNoCC,
  python3,
}:
stdenvNoCC.mkDerivation {
  pname = "certreq";
  version = "1.0.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = ./certreq.py;
  };

  buildInputs = [
    (python3.withPackages (
      ps: with ps; [
        click
        cryptography
      ]
    ))
  ];

  installPhase = ''
    runHook preInstall
    install -D -m 0755 certreq.py $out/bin/certreq
    runHook postInstall
  '';
}
