{ config, pkgs, username, homeDirectory, ... }:
let
  clone = pkgs.concatTextFile {
    name = "clone";
    files = [ ./git/clone ];
    executable = true;
    destination = "/bin/clone";
  };
  darkmode = pkgs.concatTextFile {
    name = "darkmode";
    files = [ ./darkmode ];
    executable = true;
    destination = "/bin/darkmode";
  };
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs;
    [ exa fd fzf httpie mosh nixfmt ripgrep rnix-lsp vim ]
    ++ [ clone darkmode ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.sessionPath = [ "${config.home.profileDirectory}/bin" ];
  home.sessionVariables = {
    EDITOR = "vim";
    RIPGREP_CONFIG_PATH = ./ripgrep.rc;
    FZF_MARKS_FILE = "${config.xdg.configHome}/fzf-marks/bookmarks";
  };

  home.shellAliases = { ls = "exa"; };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Shell
  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "emacs";
    enableSyntaxHighlighting = true;
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    initExtra = "source ${./zsh/zsh_prompt}";
    initExtraBeforeCompInit = ''
      zstyle ':completion:*' completer _complete _ignored _correct _approximate
      zstyle ':completion:*' matcher-list "" 'm:{[:lower:]}={[:upper:]}'
    '';
    initExtraFirst = ''
      if [ "$TERM" = "tramp" ]; then
          unsetopt zle
          PS1='$ '
          return
      fi
    '';
    plugins = [
      {
        name = "fzf-marks";
        src = pkgs.fetchFromGitHub {
          owner = "urbainvaes";
          repo = "fzf-marks";
          rev = "ff3307287bba5a41bf077ac94ce636a34ed56d32";
          hash = "sha256-e6z0ePN0SrMQw/jqTJHPfFSwcLJpd2ZA6kTaj++wdIk=";
        };
      }
    ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
}
