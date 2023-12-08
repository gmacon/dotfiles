{ config, pkgs, ... }:
let
  lib = pkgs.lib;
  stdenv = pkgs.stdenv;
in
{
  home.packages = with pkgs; [
    hunspell

    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts
  ] ++ lib.lists.optionals (stdenv.isLinux) [
    _1password
    _1password-gui
    firefox
    slack
    zotero
  ];

  home.sessionVariables = {
    DICPATH = "${config.xdg.dataHome}/hunspell";
    MOZ_ENABLE_WAYLAND = "1";
  };
  home.file."${config.xdg.dataHome}/hunspell".source = "${pkgs.hunspellDicts.en_US}/share/hunspell";

  fonts.fontconfig.enable = true;

  # Emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ../config/emacs/init.el;
      package = pkgs.emacs29-pgtk;
      alwaysEnsure = true;
    };
  };
  home.file."${config.xdg.configHome}/emacs/init.el".source = ../config/emacs/init.el;
}
