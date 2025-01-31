{ sources, ... }:
{
  nixpkgs = {
    overlays = [
      (import sources.emacs)
      (self: super: { nix-direnv = self.callPackage sources.nix-direnv { }; })
      (import ./../nix/overlay.nix)
    ];
    config = {
      allowUnfree = true;
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
