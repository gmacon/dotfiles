{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    flake-graph
    hunspell
    remmina

    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts
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
      extraEmacsPackages = epkgs: [ epkgs.treesit-grammars.with-all-grammars ];
      alwaysEnsure = true;
    };
  };
  home.file."${config.xdg.configHome}/emacs/init.el".source = ../config/emacs/init.el;

  # Kitty
  programs.kitty = {
    enable = true;
    font.name = "FiraCode";
    theme = "Solarized Light";
    settings = {
      shell = "zsh";
    };
  };
}
