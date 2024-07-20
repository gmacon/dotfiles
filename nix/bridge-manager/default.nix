{ lib, buildGoModule, fetchFromGitHub }: buildGoModule rec {
  pname = "bridge-manager";
  version = "0.12.0";
  src = fetchFromGitHub {
    owner = "beeper";
    repo = "bridge-manager";
    rev = "v${version}";
    hash = "sha256-xaBLI5Y7PxHbmlwD72AKNrgnz3D+3WVhb2GJr5cmyfs=";
  };
  vendorHash = "sha256-VnqihTEGfrLxRfuscrWWBbhZ/tr8BhVnCd+FKblW5gI=";
  ldflags = [
    "-X main.Tag=v${version}"
  ];
  meta = {
    homepage = "https://github.com/beeper/bridge-manager";
    license = lib.licenses.asl20;
    mainProgram = "bbctl";
  };
}
