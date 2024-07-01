self: super: {
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (
      pySelf: pySuper: {
        horsephrase = pySelf.callPackage ./horsephrase.nix { };
      }
    )
  ];

  cwtch = self.callPackage ./cwtch/package.nix { };
  cwtch-ui = self.callPackage ./cwtch-ui/package.nix {
    flutter = self.flutter313;
  };

  display-switch = self.callPackage ./display-switch.nix { };

  acsaml = self.callPackage ./acsaml.nix { };
  certreq = self.callPackage ./certreq { };
  flake-graph = self.callPackage ./flake-graph { };
  gitHelpers = self.callPackage ./git-helpers { };
  pinpal = self.python3.pkgs.callPackage ./pinpal.nix { };
  pushover = self.callPackage ./pushover.nix { };
  rsync-git = self.callPackage ./rsync-git.nix { };
  wordle = self.callPackage ./wordle.nix { };
}
