# Based on
# https://github.com/lucasew/nixcfg/blob/a216ebd3636fe1d0d441d07cc23a964ef139c704/nix/pkgs/wrapWine.nix
{ pkgs }:
let
  inherit (builtins) length concatStringsSep;
  inherit (pkgs) lib cabextract winetricks writeShellScriptBin;
  inherit (lib) makeBinPath;
in
{ is64bits ? false
, wine ? if is64bits then pkgs.wineWowPackages.stable else pkgs.wine
, wineFlags ? ""
, executable
, chdir ? null
, name
, tricks ? [ ]
, setupScript ? ""
, firstrunScript ? ""
, home ? ""
}:
let
  wineBin = "${wine}/bin/wine${if is64bits then "64" else ""}";
  requiredPackages = [
    cabextract
    wine
    winetricks
  ];
  WINENIX_PROFILES = "$HOME/.config/wine-nix/profiles";
  PATH = makeBinPath requiredPackages;
  NAME = name;
  HOME = if home == "" then "${WINENIX_PROFILES}/${name}" else home;
  WINEARCH = if is64bits then "win64" else "win32";
  setupHook = ''
    ${wine}/bin/wineboot
  '';
  tricksHook =
    if (length tricks) > 0 then
      let
        tricksStr = concatStringsSep " " tricks;
        tricksCmd = ''
          winetricks ${tricksStr}
        '';
      in
      tricksCmd
    else
      "";
  script = writeShellScriptBin name ''
    export APP_NAME="${NAME}"
    export WINEARCH=${WINEARCH}
    export WINE_NIX="$HOME/.cache/wine-nix" # define before overriding HOME
    export WINE_NIX_PROFILES="${WINENIX_PROFILES}"
    export PATH=$PATH:${PATH}
    export HOME="${HOME}"
    mkdir -p "$HOME"
    export WINEPREFIX="$WINE_NIX/${name}"
    export EXECUTABLE="${executable}"
    mkdir -p "$WINE_NIX" "$WINE_NIX_PROFILES"
    ${setupScript}
    if [ ! -d "$WINEPREFIX" ] # if the prefix does not exist
    then
      ${setupHook}
      wineserver -w
      ${tricksHook}
      rm "$WINEPREFIX/drive_c/users/$USER" -rf
      ln -s "$HOME" "$WINEPREFIX/drive_c/users/$USER"
      ${firstrunScript}
    fi
    ${if chdir != null then ''cd "${chdir}"'' else ""}
    if [ ! "$REPL" == "" ]; # if $REPL is setup then start a shell in the context
    then
      bash
      exit 0
    fi

    ${wineBin} ${wineFlags} "$EXECUTABLE" "$@"
    wineserver -w
  '';
in
script
