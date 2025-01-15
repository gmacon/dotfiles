{
  pkgs,
  ...
}:
let
  darkmode = pkgs.concatTextFile {
    name = "darkmode";
    files = [ ../config/darkmode ];
    executable = true;
    destination = "/bin/darkmode";
  };
in
{
  home.packages = [
    darkmode
  ];
  home.sessionPath = [ "/usr/local/bin" ];
}
