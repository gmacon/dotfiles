{
  cwtch,
  fetchgit,
  flutter,
  zenity,
  lib,
  tor,
}:
let
  runtimeBinDependencies = [
    tor
    zenity
  ];
in
flutter.buildFlutterApplication rec {
  pname = "cwtch-ui";
  version = "1.15.1";
  src = fetchgit {
    url = "https://git.openprivacy.ca/cwtch.im/cwtch-ui";
    rev = "v${version}";
    hash = "sha256-+UtWhQMhm0UjY0kx3B5TwcBFhUfJma3rpeYls4XWy7I=";
  };

  pubspecLock = lib.importJSON ./pubspec.json;
  gitHashes = {
    flutter_gherkin = "sha256-Y8tR84kkczQPBwh7cGhPFAAqrMZKRfGp/02huPaaQZg=";
  };

  flutterBuildFlags = [
    "--dart-define"
    "BUILD_VER=${version}"
    "--dart-define"
    "BUILD_DATE=1980-01-01-00:00"
  ];

  # These things are added to LD_LIBRARY_PATH, but not PATH
  runtimeDependencies = [ cwtch ];

  extraWrapProgramArgs = "--prefix PATH : ${lib.makeBinPath runtimeBinDependencies}";

  postInstall = ''
    mkdir -p $out/share/applications
    sed "s|PREFIX|$out|" linux/cwtch.template.desktop >$out/share/applications/cwtch.desktop
  '';

  meta = {
    description = "A decentralized, privacy-preserving, multi-party messaging app";
    homepage = "https://cwtch.im/";
    changelog = "https://cwtch.im/changelog/";
    license = lib.licenses.mit;
    mainProgram = "cwtch";
    platforms = lib.intersectLists lib.platforms.linux lib.platforms.x86;
    maintainers = [ lib.maintainers.gmacon ];
  };
}
