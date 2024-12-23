self: super: {
  display-switch = self.callPackage ./display-switch.nix { };

  mautrix-gmessages = self.callPackage ./mautrix-gmessages { };

  acsaml = self.callPackage ./acsaml.nix { };
  certreq = self.callPackage ./certreq { };
  flake-graph = self.callPackage ./flake-graph { };
  gitHelpers = self.callPackage ./git-helpers { };
  nix-direnv-gc = self.callPackage ./nix-direnv-gc.nix { };
  pushover = self.callPackage ./pushover.nix { };
  rsync-git = self.callPackage ./rsync-git.nix { };
  wordle = self.callPackage ./wordle.nix { };

  wrapWine = import ./wrapWine.nix { pkgs = self; };
  genopro = self.callPackage ./genopro.nix { };

  _1password-gui = super._1password-gui.overrideAttrs (_old: {
    postFixup = ''
      wrapProgram $out/bin/1password --set ELECTRON_OZONE_PLATFORM_HINT x11
    '';
  });
}
