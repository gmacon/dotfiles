{ lib, writeShellApplication, openconnect }: writeShellApplication {
  name = "acsaml";
  text = ''
    browser="$(command -v xdg-open || command -v open)"
    COOKIE=

    sudo -v

    eval "$(
        ${lib.getExe openconnect} \
            "$@" \
            --authenticate \
            --external-browser "$browser" \
            --useragent "AnyConnect Linux_64")"

    if [ -z "$COOKIE" ]; then
        echo "OpenConnect didn't set the expected variables!" 1>&2
        exit 1
    fi

    sudo ${lib.getExe openconnect} \
         --servercert "$FINGERPRINT" \
         "$CONNECT_URL" \
         --cookie-on-stdin \
         ''${RESOLVE:+--resolve "$RESOLVE"} <<< "$COOKIE"
  '';
}
