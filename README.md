# Nix Configurations

Bootstrapping for Alien Nix:

1.  [Install Nix](https://nixos.org/download.html)
2.  Install [nsncd](https://github.com/twosigma/nsncd)
3.  Clone (or otherwise obtain) this repository.
4.  Run `./sm.sh work-desktop`
5.  Run `./hm.sh work-desktop`
    (replacing `work-desktop` with the appropriate attribute).

Bootstrapping for NixOS:

1.  Clone (or otherwise obtain) this repository.
2.  Run `nix-shell` to get a shell containing Colmena.
3.  Run `colmena apply-local --sudo`.
