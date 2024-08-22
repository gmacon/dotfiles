{
  buildGoModule,
  fetchgit,
  lib,
}:
buildGoModule rec {
  pname = "libcwtch";
  version = "0.1.2";
  src = fetchgit {
    url = "https://git.openprivacy.ca/cwtch.im/autobindings.git";
    rev = "v${version}";
    hash = "sha256-nf3NAS8RsuyRnO+p+gP+HVOKVSBxSGudOyrPvFoLnYE=";
  };

  vendorHash = "sha256-sMAilt5lq+5T2fwSD18SN66gUi4puOq8cexfRoZvOKk=";
  overrideModAttrs = (
    old: {
      preBuild = ''
        make lib.go
      '';
    }
  );

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '$(shell git describe --tags)' v${version} \
      --replace-fail '$(shell git log -1 --format=%cd --date=format:%G-%m-%d-%H-%M)' 1980-01-01-00-00
  '';

  buildPhase = ''
    runHook preBuild
    make linux
    runHook postBuild
  '';

  doCheck = false;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib $out/include
    cp build/linux/libCwtch.h $out/include/libCwtch.h
    cp build/linux/libCwtch.*.so $out/lib/libCwtch.so
    runHook postInstall
  '';

  meta = {
    description = "A decentralized, privacy-preserving, multi-party messaging protocol";
    homepage = "https://cwtch.im/";
    changelog = "https://cwtch.im/changelog/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.gmacon ];
  };
}
