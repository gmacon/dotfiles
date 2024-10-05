#!/usr/bin/env bash

set -euo pipefail

sudo nixos-rebuild boot --flake .
sudo nix-collect-garbage --delete-older-than 30d
nix-collect-garbage --delete-older-than 30d
diff -u <(readlink /run/booted-system/{initrd,kernel,kernel-modules}) <(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})
