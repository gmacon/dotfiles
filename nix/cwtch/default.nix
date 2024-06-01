{ fetchgit
, flutter
, gnome
, lib
, libcwtch
, tor
}:
let
  runtimeBinDependencies = [ tor gnome.zenity ];
in
flutter.buildFlutterApplication rec {
  pname = "cwtch";
  version = "1.14.7";
  src = fetchgit {
    url = "https://git.openprivacy.ca/cwtch.im/cwtch-ui";
    rev = "v${version}";
    hash = "sha256-c02s8YFrLwIpvLVMM2d7Ynk02ibIgZmRKOI+mkrttLk=";
  };

  depsListFile = ./deps.json;
  pubspecLock = lib.importJSON ./pubspec.json;
  gitHashes = {
    flutter_gherkin = "sha256-NshzlM21x7jSFjP+M0N4S7aV3BcORkZPvzNDwJxuVSA=";
  };
  vendorHash = "sha256-QRmhprObwn9jAbX+GQLDtHUPCQ6WX0AgTjFqTwCceTc=";
  flutterBuildFlags = [
    "--dart-define"
    "BUILD_VER=${version}"
    "--dart-define"
    "BUILD_DATE=$(date +%G-%m-%d-%H-%M --date=@$SOURCE_DATE_EPOCH)"
  ];

  # These things are added to LD_LIBRARY_PATH, but not PATH
  runtimeDependencies = [ libcwtch ];

  extraWrapProgramArgs = "--prefix PATH : ${lib.makeBinPath runtimeBinDependencies}";

  postInstall = ''
    mkdir -p $out/share/applications
    sed "s|PREFIX|$out|" linux/cwtch.template.desktop >$out/share/applications/cwtch.desktop
  '';


  meta = with lib; {
    description = "A decentralized, privacy-preserving, multi-party messaging app";
    homePage = "https://cwtch.im/";
    changelog = "https://cwtch.im/changelog/";
    license = licenses.mit;
    mainProgram = "cwtch";
    platforms = platforms.linux;
  };
}
