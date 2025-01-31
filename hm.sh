#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")"

target="${1?Need a target}"
shift

cmd="${1:-switch}"
shift

nixpkgs_pin="$(nix eval --raw -f npins/default.nix nixpkgs-stable)"
homemanager_pin="$(nix eval --raw -f npins/default.nix home-manager)"

NIX_PATH="nixpkgs=$nixpkgs_pin:home-manager=$homemanager_pin" home-manager -f home.nix -A "$target" "$@" "$cmd"
