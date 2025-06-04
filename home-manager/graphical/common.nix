{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      flake-graph
      hunspell
      noto-fonts
      remmina
      ;
    inherit (pkgs.nerd-fonts)
      fira-code
      ;
  };

  home.sessionVariables = {
    DICPATH = "${config.xdg.dataHome}/hunspell";
    MOZ_ENABLE_WAYLAND = "1";
  };
  home.file."${config.xdg.dataHome}/hunspell".source = "${pkgs.hunspellDicts.en_US}/share/hunspell";

  fonts.fontconfig.enable = true;

  # Set up 1Password SSH Agent
  programs.zsh.envExtra = ''
    if [ -z "$SSH_CONNECTION" ]; then
      export SSH_AUTH_SOCK="$HOME/.1password/agent.sock";
    fi
  '';

  # Emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ../config/emacs/init.el;
      extraEmacsPackages = epkgs: [
        epkgs.treesit-grammars.with-all-grammars
      ];
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
    extraConfig = ''
      mouse_map left click ungrabbed
    '';
  };
}
