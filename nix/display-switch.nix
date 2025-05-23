{
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  systemd,
}:
rustPlatform.buildRustPackage rec {
  pname = "display_switch";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "haimgel";
    repo = "display-switch";
    rev = version;
    hash = "sha256-pUZNIEpzFZN5fc6TBedhL+7LJdw2R10w3BqzvLt+RYk=";
  };
  cargoHash = "sha256-AF6A880V4rZSxpfdnYNbXSi0Mz1Ig+ZOFMtI6pxKqeA=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd ];
  doCheck = false;

  meta = {
    mainProgram = "display_switch";
  };
}
