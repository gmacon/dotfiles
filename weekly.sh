#!/usr/bin/env bash

set -x
set -euo pipefail

trap 'rm -rf before after' EXIT

rm -rf .gcroots

colmena build --keep-result --on argon
mv .gcroots/* before

npins update

colmena build --keep-result --on argon
mv .gcroots/* after

nvd diff before after

read

git add npins
git commit -m 'Update inputs'

colmena apply --reboot --keep-result

echo Ready for root?
read
colmena apply-local boot --sudo
sudo nix-collect-garbage --delete-older-than 30d

nix-collect-garbage --delete-older-than 30d
