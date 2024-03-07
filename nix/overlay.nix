self: super: {
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (
      pySelf: pySuper: {
        horsephrase = pySelf.callPackage ./horsephrase.nix { };
      }
    )
  ];
  pinpal = self.python3.pkgs.callPackage ./pinpal.nix { };
  pushover = self.callPackage ./pushover.nix { };
  rsync-git = self.callPackage ./rsync-git.nix { };
  wordle = self.callPackage ./wordle.nix { };
}
