#!/usr/bin/env bash

set -x
set -euo pipefail

trap 'rm -rf before after' EXIT

before_drv="$(colmena eval --instantiate ./merged.nix)"
before="$(nix-store --realise $before_drv)"

npins update

after_drv="$(colmena eval --instantiate ./merged.nix)"
after="$(nix-store --realise $after_drv)"

version_diff="$(nvd diff $before $after)"

read

git add npins
git commit -m "Update inputs\n\n$version_diff"

colmena apply --reboot --keep-result

echo Ready for root?
read
colmena apply-local boot --sudo
sudo nix-collect-garbage --delete-older-than 30d

nix-collect-garbage --delete-older-than 30d
