{ lib, sources, ... }:
{
  nixpkgs = {
    overlays = [
      (import sources.emacs)
      (self: super: { nix-direnv = self.callPackage sources.nix-direnv { }; })
      (import ./../nix/overlay.nix)
    ];
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "1password"
          "1password-cli"
          "beeper"
          "slack"
          "tarsnap"
          "vista-fonts"
          "zoom"
        ];
      permittedInsecurePackages = [
        # Non-constant-time crypto primitives.
        # In the mautrix bridges,
        # I feel like this is low risk
        # since I'm controlling both endpoints.
        "olm-3.2.16"
      ];
    };
  };
}
