final: prev: {
  kdePackages = prev.kdePackages.overrideScope (
    kdeFinal: kdePrev: {
      plasma-desktop = kdePrev.plasma-desktop.overrideAttrs (old: {
        patches = old.patches or [ ] ++ [
          ./lockscreen-ignore-first-mouse-move.patch
        ];
      });
    }
  );

  display-switch = final.callPackage ./display-switch.nix { };

  acsaml = final.callPackage ./acsaml { };
  attic-quick-token = final.callPackage ./attic-quick-token.nix { };
  certreq = final.callPackage ./certreq { };
  flake-graph = final.callPackage ./flake-graph { };
  gitHelpers = final.callPackage ./git-helpers { };
  nix-direnv-gc = final.callPackage ./nix-direnv-gc.nix { };
  pushover = final.callPackage ./pushover.nix { };
  rsync-git = final.callPackage ./rsync-git.nix { };
  wordle = final.callPackage ./wordle.nix { };

  wrapWine = import ./wrapWine.nix { pkgs = final; };
  genopro = final.callPackage ./genopro.nix { };

  # https://forums.zotero.org/discussion/comment/463954/#Comment_463954
  zotero-gtri = prev.zotero.overrideAttrs (
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
        final.unzip
        final.zip
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

  _1password-gui = prev._1password-gui.overrideAttrs (_old: {
    postFixup = ''
      wrapProgram $out/bin/1password --set ELECTRON_OZONE_PLATFORM_HINT x11
    '';
  });
}
