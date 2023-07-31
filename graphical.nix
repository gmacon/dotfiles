{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    hunspell
  ];
  home.sessionVariables.DICPATH = "${config.xdg.dataHome}/hunspell";
  home.file."${config.xdg.dataHome}/hunspell".source = "${pkgs.hunspellDicts.en_US}/share/hunspell";

  # Emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      package = pkgs.emacs29-pgtk;
      alwaysEnsure = true;
    };
  };
  home.file."${config.xdg.configHome}/emacs/init.el".source = ./emacs/init.el;
}
