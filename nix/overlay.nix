self: super: {
  pythonPackagesExtensions = super.pythonPackagesExtensions ++ [
    (
      pySelf: pySuper: {
        horsephrase = pySelf.callPackage ./horsephrase.nix { };
      }
    )
  ];

  libcwtch = self.callPackage ./libcwtch.nix { };
  cwtch = self.callPackage ./cwtch { };

  display-switch = self.callPackage ./display-switch.nix { };

  tarsnapper = super.tarsnapper.overridePythonAttrs (old: {
    checkPhase = ''
      runHook preCheck
      nosetests tests
      runHook postCheck
    '';
  });

  acsaml = self.callPackage ./acsaml.nix { };
  certreq = self.callPackage ./certreq { };
  gitHelpers = self.callPackage ./git-helpers { };
  pinpal = self.python3.pkgs.callPackage ./pinpal.nix { };
  pushover = self.callPackage ./pushover.nix { };
  rsync-git = self.callPackage ./rsync-git.nix { };
  wordle = self.callPackage ./wordle.nix { };
}
