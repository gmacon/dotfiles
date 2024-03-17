{ stdenv, lib, buildGoModule, fetchgit }: buildGoModule rec {
  pname = "cwtch";
  version = "0.0.14";
  versionDate = "2024-02-27-02-07";
  src = fetchgit {
    url = "https://git.openprivacy.ca/cwtch.im/autobindings.git";
    rev = "v${version}";
    hash = "sha256-cVvxsT0aTCYT7WGRl6Pwy69cwNQpxCccTsl738vJobA=";
  };

  vendorHash = "sha256-1t0jiRpWNfU530phUV9KgRatsOH4G3k3oxFBkokCLwc=";
  overrideModAttrs = (old: {
    preBuild = ''
      make lib.go
    '';
  });

  postPatch = ''
    substituteInPlace Makefile \
      --replace '$(shell git describe --tags)' v${version} \
      --replace '$(shell git log -1 --format=%cd --date=format:%G-%m-%d-%H-%M)' ${versionDate}
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

  meta = with lib; {
    description = "A decentralized, privacy-preserving, multi-party messaging protocol";
    homePage = "https://cwtch.im/";
    changelog = "https://cwtch.im/changelog/";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
