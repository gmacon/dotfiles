#!/usr/bin/env bash

set -x
set -euo pipefail

before_drv="$(colmena eval --instantiate ./merged.nix)"
nix-store --realise --log-format internal-json --add-root before "$before_drv" |& nom --json

npins update

after_drv="$(colmena eval --instantiate ./merged.nix)"
nix-store --realise --log-format internal-json --add-root after "$after_drv" |& nom --json

version_diff="$(nvd diff before after)"
echo "$version_diff"
rm before after

read

git add npins
git commit -m "Update inputs

$version_diff"

colmena apply --reboot --keep-result

echo Ready for root?
read
colmena apply-local boot --sudo
sudo nix-collect-garbage --delete-older-than 30d

nix-collect-garbage --delete-older-than 30d
