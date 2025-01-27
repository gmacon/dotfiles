{
  fetchFromGitLab,
  writeShellApplication,
  openconnect,
}:
let
  openconnect-git = openconnect.overrideAttrs {
    version = "9.12+git";
    src = fetchFromGitLab {
      owner = "openconnect";
      repo = "openconnect";
      rev = "f17fe20d337b400b476a73326de642a9f63b59c8"; # head 1/21/25
      hash = "sha256-OBEojqOf7cmGtDa9ToPaJUHrmBhq19/CyZ5agbP7WUw=";
    };
  };
in
writeShellApplication {
  name = "acsaml";
  runtimeInputs = [ openconnect-git ];
  text = ''
    openconnect="$(command -v openconnect)"
    browser="$(command -v xdg-open || command -v open)"
    COOKIE=

    sudo -v

    eval "$(
        "$openconnect" \
            "$@" \
            --authenticate \
            --external-browser "$browser" \
            --useragent "AnyConnect Linux_64")"

    if [ -z "$COOKIE" ]; then
        echo "OpenConnect didn't set the expected variables!" 1>&2
        exit 1
    fi

    sudo "$openconnect" \
         --servercert "$FINGERPRINT" \
         "$CONNECT_URL" \
         --cookie-on-stdin \
         ''${RESOLVE:+--resolve "$RESOLVE"} <<< "$COOKIE"
  '';
}
