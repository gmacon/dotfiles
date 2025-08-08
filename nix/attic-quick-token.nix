{
  attic-server,
  writeShellApplication,
}:
writeShellApplication {
  name = "attic-quick-token";
  runtimeInputs = [
    attic-server
  ];
  text = ''
    cache="''${1?}"
    shift

    echo "Admin token for $cache"
    atticadm make-token "$@" \
      --sub admin \
      --validity 1y \
      --pull "$cache" \
      --push "$cache" \
      --delete "$cache" \
      --create-cache "$cache" \
      --configure-cache "$cache" \
      --configure-cache-retention "$cache" \
      --destroy-cache "$cache"

    echo "CI token for $cache"
    atticadm make-token "$@" \
      --sub ci \
      --validity 1y \
      --push "$cache"
  '';
}
