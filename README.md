# Home Manager Configuration

Bootstrapping:

1.  [Install Nix](https://nixos.org/download.html)
2.  Run:

    ```console
    $ nix build \
          --extra-experimental-features nix-command \
          --extra-experimental-features flakes \
          github:gmacon/dotfiles#homeConfigurations.home-laptop.activationPackage
    $ ./result/activate
    $ rm result
    $ clone https://github.com/gmacon/dotfiles
    ```
    
Updates:

```console
$ home-manager switch --flake ~/code/github.com/gmacon/dotfiles#home-laptop
```
