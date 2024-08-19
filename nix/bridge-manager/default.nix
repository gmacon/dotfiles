{ lib, buildGoModule, fetchFromGitHub }: buildGoModule rec {
  pname = "bridge-manager";
  version = "0.12.1";
  src = fetchFromGitHub {
    owner = "beeper";
    repo = "bridge-manager";
    rev = "v${version}";
    hash = "sha256-MAve7ZNS20XBJ7Qp3mehznli04+MS7RiVWW1txdf19U=";
  };
  vendorHash = "sha256-uz4pao8Y/Sb3fffi9d0lbWQEUMohbthA6t6k6PfQz2M=";
  ldflags = [
    "-X main.Tag=v${version}"
  ];
  meta = {
    homepage = "https://github.com/beeper/bridge-manager";
    license = lib.licenses.asl20;
    mainProgram = "bbctl";
  };
}
