{ lib
, buildGoModule
, fetchFromGitHub
, olm
}:

buildGoModule rec {
  pname = "mautrix-gmessages";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "mautrix";
    repo = "gmessages";
    rev = "v${version}";
    hash = "sha256-Qh5jlvHOEtEt1IKfSYQsSWzfCrCoo8zVDCZDUZlPKEw=";
  };

  postUnpack = "set -x";

  vendorHash = "sha256-VA+PC7TCEGTXG9yRcroPIVQlA5lzq9GlNRgMNPWTMSg=";

  ldflags = [ "-s" "-w" ];

  buildInputs = [ olm ];

  excludedPackages = [ "libgm" ];

  meta = with lib; {
    description = "A Matrix-Google Messages puppeting bridge";
    homepage = "https://github.com/mautrix/gmessages";
    changelog = "https://github.com/mautrix/gmessages/blob/${src.rev}/CHANGELOG.md";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ gmacon ];
    mainProgram = "mautrix-gmessages";
  };
}
