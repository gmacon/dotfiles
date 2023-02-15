{ config, pkgs, penumbra, ... }:
let
  plistToJson = source: pkgs.runCommand "output" { } ''
    ${pkgs.python3}/bin/python -c "import json, plistlib, sys; json.dump(plistlib.load(sys.stdin.buffer), sys.stdout)" <${source} >$out
  '';
  readPlist = source: builtins.fromJSON (builtins.readFile (plistToJson source));
  darkmode = pkgs.concatTextFile {
    name = "darkmode";
    files = [ ./darkmode ];
    executable = true;
    destination = "/bin/darkmode";
  };
in
{
  home.packages = with pkgs; [ iterm2 darkmode ];
  home.sessionPath = [ "/usr/local/bin" ];
  home.shellAliases = {
    nix = "caffeinate nix";
    home-manager = "caffeinate home-manager";
  };
  programs.git.extraConfig.credential.helper = "osxkeychain";

  # Terminal Emulator
  targets.darwin.defaults."com.googlecode.iterm2" = {
    "Custom Color Presets" = {
      "penumbra_light" = readPlist "${penumbra}/iTerm2/penumbra_light.itermcolors";
      "penumbra_dark" = readPlist "${penumbra}/iTerm2/penumbra_dark.itermcolors";
      "penumbra_dark+" = readPlist "${penumbra}/iTerm2/penumbra_dark+.itermcolors";
      "penumbra_dark++" = readPlist "${penumbra}/iTerm2/penumbra_dark++.itermcolors";
    };
  };
  home.file."Library/Application Support/iTerm2/Scripts/autotheme.py".source =
    ./iterm2/autotheme.py;
}
