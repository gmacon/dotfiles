{ config, pkgs, ... }:
let
  darkmode = pkgs.concatTextFile {
    name = "darkmode";
    files = [ ./darkmode ];
    executable = true;
    destination = "/bin/darkmode";
  };
in
{
  home.file = {
    "Library/Application Support/iTerm2/Scripts/autotheme.py".source =
      ./iterm2/autotheme.py;
  };
  home.packages = [ darkmode ];
  home.sessionPath = [ "/usr/local/bin" ];
  home.shellAliases = {
    nix = "caffeinate nix";
    home-manager = "caffeinate home-manager";
  };
  programs.git.extraConfig.credential.helper = "osxkeychain";
}
