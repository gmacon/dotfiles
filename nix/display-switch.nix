{ lib, fetchFromGitHub, rustPlatform, pkg-config, systemd }: rustPlatform.buildRustPackage rec {
  pname = "display_switch";
  version = "1.3.1";
  src = fetchFromGitHub {
    owner = "haimgel";
    repo = "display-switch";
    rev = version;
    hash = "sha256-9J9VaBUrsWbRmdbfI2lzYIWPtWcZqZgg6jEZTEiHHtM=";
  };
  cargoHash = "sha256-G+9HFDkdPp7nFfz/SPKUIPSAqZmWVgketF/XxnOTUyc=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd ];
  doCheck = false;

  meta = with lib; {
    mainProgram = "display_switch";
  };
}
