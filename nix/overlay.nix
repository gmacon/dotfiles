self: super: {
  display-switch = self.callPackage ./display-switch.nix { };

  mautrix-gmessages = self.callPackage ./mautrix-gmessages { };

  acsaml = self.callPackage ./acsaml { };
  certreq = self.callPackage ./certreq { };
  flake-graph = self.callPackage ./flake-graph { };
  gitHelpers = self.callPackage ./git-helpers { };
  nix-direnv-gc = self.callPackage ./nix-direnv-gc.nix { };
  pushover = self.callPackage ./pushover.nix { };
  rsync-git = self.callPackage ./rsync-git.nix { };
  wordle = self.callPackage ./wordle.nix { };

  wrapWine = import ./wrapWine.nix { pkgs = self; };
  genopro = self.callPackage ./genopro.nix { };

  # https://forums.zotero.org/discussion/comment/463954/#Comment_463954
  zotero-gtri = super.zotero.overrideAttrs (
    old:
    let
      # Domain where Zotero self-host server is running
      domain = "glados.ctisl.gtri.org";
      # Set to "s" if there's a TLS proxy on the server,
      # or to "" otherwise.
      s = "";
    in
    {
      nativeBuildInputs = old.nativeBuildInputs ++ [
        self.unzip
        self.zip
      ];
      postPatch = ''
        sourceDir=$(pwd)
        pushd $(mktemp -d)
        unzip $sourceDir/app/omni.ja resource/config.js
        sed -i~ \
          -e '/DOMAIN_NAME/c DOMAIN_NAME: "${domain}",' \
          -e '/BASE_URI/c BASE_URI: "http${s}://${domain}:8080/",' \
          -e '/WWW_BASE_URL/c WWW_BASE_URL: "http${s}://${domain}:8080/",' \
          -e '/PROXY_AUTH_URL/c PROXY_AUTH_URL: "",' \
          -e '/API_URL/c API_URL: "http${s}://${domain}:8080/",' \
          -e '/STREAMING_URL/c STREAMING_URL: "ws${s}://${domain}:8081/",' \
          resource/config.js
        zip $sourceDir/app/omni.ja resource/config.js
        popd
      '';
      meta = old.meta // {
        platforms = [ "x86_64-linux" ];
      };
    }
  );

  _1password-gui = super._1password-gui.overrideAttrs (_old: {
    postFixup = ''
      wrapProgram $out/bin/1password --set ELECTRON_OZONE_PLATFORM_HINT x11
    '';
  });
}
