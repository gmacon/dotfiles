# Home Manager Configuration

Bootstrapping:

1.  [Install Nix](https://nixos.org/download.html)
2.  Clone this repo somewhere handy.
    (I use `~/.dotfiles` for historical reasons,
    but it doesn't really matter where.)
3.  Run:

    ```console
    $ nix build ~/.dotfiles#homeConfigurations.home-laptop.activationPackage
    $ ./result/activate
    $ rm result
    ```
    
Updates:

```console
$ home-manager switch --flake ~/.dotfiles#home-laptop
```
