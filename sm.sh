#!/usr/bin/env bash

set -euo pipefail

target="${1?}"
shift

builtEnv="$(nix build --no-link --print-out-paths -f ./system-manager "$target")"

sudo "$builtEnv/bin/register-profile"
sudo "$builtEnv/bin/activate"
