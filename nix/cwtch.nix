{ stdenv
, fetchFromGitea
, lib
, autoPatchelfHook
, glib
, zlib
}: stdenv.mkDerivation (final: {
  name = "cwtch";
  version = "1.14.7";
  src = fetchFromGitea {
    domain = "git.openprivacy.ca";
    owner = "cwtch.im";
    repo = "cwtch-ui";
    hash = "";
  };

  buildInputs = [
    glib
    zlib
  ];

  meta = with lib; {
    description = "A decentralized, privacy-preserving, multi-party messaging app";
    homePage = "https://cwtch.im/";
    changelog = "https://cwtch.im/changelog/";
    license = licenses.mit;
    mainProgram = "cwtch";
    platforms = platforms.linux;
  };
})
