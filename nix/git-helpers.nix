{ stdenv, python3 }: stdenv.mkDerivation {
  name = "git-helpers";
  src = ../config/git;
  buildInputs = [ python3 ];
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m 0755 git-prune-branches clone $out/bin
    runHook postInstall
  '';
}
