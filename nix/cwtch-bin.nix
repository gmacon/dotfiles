{ atkmm
, autoPatchelfHook
, cairo
, fetchurl
, gdk-pixbuf
, glib
, gtk3
, harfbuzz
, lib
, libepoxy
, pango
, stdenv
, zlib
}: stdenv.mkDerivation (final: {
  name = "cwtch";
  version = "1.14.7";
  src = fetchurl {
    url = "https://git.openprivacy.ca/cwtch.im/cwtch-ui/releases/download/v${final.version}/cwtch-v${final.version}.tar.gz";
    hash = "sha512-Rl50F4G/NCwLuBDdL2cUVigzbAX55XOQBF1H1/PiS+K/O8iCtllareJNdmjkbHE84bm2bUth2sMrgKDcHB6ehA==";
  };

  buildInputs = [
    atkmm
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libepoxy
    pango
    stdenv.cc.cc.lib
    zlib
  ];
  nativeBuildInputs = [ autoPatchelfHook ];

  doBuild = false;
  installPhase = ''
    runHook preInstall
    INSTALL_PREFIX=$out DESKTOP_PREFIX=$out ./install.sh
    runHook postInstall
  '';

  meta = with lib; {
    description = "A decentralized, privacy-preserving, multi-party messaging app";
    homePage = "https://cwtch.im/";
    changelog = "https://cwtch.im/changelog/";
    license = licenses.mit;
    mainProgram = "cwtch";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
  };
})
