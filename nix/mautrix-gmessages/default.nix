{
  lib,
  buildGoModule,
  fetchFromGitHub,
  olm,
  # This option enables the use of an experimental pure-Go implementation of the
  # Olm protocol instead of libolm for end-to-end encryption. Using goolm is not
  # recommended by the mautrix developers, but they are interested in people
  # trying it out in non-production-critical environments and reporting any
  # issues they run into.
  withGoolm ? false,
}:
buildGoModule rec {
  pname = "mautrix-gmessages";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gmessages";
    rev = "v${version}";
    hash = "sha256-J0nlO4jYa9QjkiZTHduzTjrkw5wG/0GD1y60cwgQfZ4=";
  };

  vendorHash = "sha256-b+FUXQhNIymZLZw0NJLHK+Ka/kbpLO3Z56IlhmLmuVs=";

  ldflags = [ "-X main.Tag=${src.rev}" ];

  buildInputs = lib.optional (!withGoolm) olm;
  tags = lib.optional withGoolm "goolm";

  subPackages = [ "cmd/mautrix-gmessages" ];

  meta = with lib; {
    description = "A Matrix-Google Messages puppeting bridge";
    homepage = "https://github.com/mautrix/gmessages";
    changelog = "https://github.com/mautrix/gmessages/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ gmacon ];
    mainProgram = "mautrix-gmessages";
  };
}
