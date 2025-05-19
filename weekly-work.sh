#!/usr/bin/env bash

set -euo pipefail

main () {
    ./sm.sh work-desktop
    ./hm.sh work-desktop
    nix-collect-garbage --delete-older-than 30d
    sudo "$(command -v nix-collect-garbage)" --delete-older-than 30d
}

{ main "$@"; exit $?; }
