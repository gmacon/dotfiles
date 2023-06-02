{ config, pkgs, ... }:
{
  # Emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      package = pkgs.emacs-pgtk;
      alwaysEnsure = true;
    };
  };
  home.file."${config.xdg.configHome}/emacs/init.el".source = ./emacs/init.el;
}
