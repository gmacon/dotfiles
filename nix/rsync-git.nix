{ writeShellApplication, rsync, git }:
writeShellApplication {
  name = "rsync-git";
  runtimeInputs = [ rsync git ];
  text = ''
    usage="usage: rsync-git SRC DST <options>"
    src="''${1?$usage}"
    shift
    dst="''${1?$usage}"
    shift
    exec rsync \
      --exclude-from <(
        git -C "$src" ls-files --exclude-standard --others --ignored --directory
      ) \
      --exclude-from <(
        git -C "$src" ls-files --exclude-standard --others --directory
      ) \
      "$@" \
      "$src" "$dst"
  '';
}
