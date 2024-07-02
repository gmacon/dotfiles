{ fetchurl, wrapWine }:
let
  installer = fetchurl {
    url = "https://genopro.com/InstallGenoPro.exe";
    hash = "sha256-tqnN5RKWWgCEo2OrSI0FMvkFnTyU1PGzVPVTYJjEzPA=";
  };
in
wrapWine {
  name = "genopro";
  executable = "C:/Program Files/GenoPro/GenoPro.exe";
  tricks = [ "mfc42" ];
  firstrunScript = ''
    wine ${installer} 
  '';
}
