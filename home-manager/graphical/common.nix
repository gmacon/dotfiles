{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    flake-graph
    aspell
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    remmina

    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts
  ];

  home.file."${config.home.homeDirectory}/.aspell.conf".text = ''
    master en_US
    extra-dicts en-computers.rws,en_US-science.rws
  '';

  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

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
    themeFile = "Solarized_Light";
    settings = {
      shell = "zsh";
    };
  };
}
