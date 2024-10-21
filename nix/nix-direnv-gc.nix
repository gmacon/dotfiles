# See https://github.com/nix-community/nix-direnv/issues/529#issuecomment-2424954291
{
  coreutils,
  gawk,
  gnugrep,
  writeShellApplication,
}:
writeShellApplication {
  name = "nix-direnv-gc";
  runtimeInputs = [
    coreutils
    gawk
    gnugrep
  ];
  text = ''
    direnv_cache_pattern=''${1:-"/\.cache/direnv/layouts/"}
    if [[ $# -gt 0 ]]; then
      shift
    fi
    older_than_pattern=''${*:-"30 days ago"}
    early_dt_secs=$(date -d "$older_than_pattern" "+%s")

    all_files=$(nix-store --gc --print-roots | \
                grep "''${direnv_cache_pattern}" | \
                gawk 'FS="->" {print $1}')

    while read -r pth; do
        mtime=$(stat -c %Y -- "$pth")
        if [[ $mtime -lt $early_dt_secs ]]; then
            rm "$pth"
        fi
    done <<< "$all_files"
  '';
}
