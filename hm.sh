#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

target="${1?Need a target}"
shift

cmd="${1:-switch}"
shift || true

nixpkgs_pin="$(nix eval --raw -f npins/default.nix nixpkgs-stable)"
homemanager_pin="$(nix eval --raw -f npins/default.nix home-manager)"

home_manager="$(nix build --no-link --print-out-paths -f hm.nix)"

NIX_PATH="nixpkgs=$nixpkgs_pin:home-manager=$homemanager_pin" \
        "$home_manager/bin/home-manager" \
        -f home.nix \
        -A "$target" \
        "$@" \
        "$cmd"
