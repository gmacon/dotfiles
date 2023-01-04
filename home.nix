{ config, pkgs, username, userEmail, homeDirectory, ... }:
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
  skiplist = pkgs.runCommand "skiplist" { } ''
    cut -f1 ${./git/skipList} | sort > $out
  '';
in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs;
    [
      bat
      cachix
      cookiecutter
      exa
      fd
      fzf
      httpie
      mosh
      ncdu
      nixfmt
      openssh
      ripgrep
      rnix-lsp
      vim
    ] ++ [ clone darkmode ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.11";

  home.sessionVariables = {
    EDITOR = "${pkgs.vim}/bin/vim";
    RIPGREP_CONFIG_PATH = ./ripgrep.rc;
    FZF_MARKS_FILE = "${config.xdg.configHome}/fzf-marks/bookmarks";
  };

  home.file = {
    "${config.xdg.configHome}/bat/config".text = ''
      --theme=base16
    '';
    "${config.xdg.configHome}/cookiecutter/cookiecutter.yaml".text = ''
      default_context:
        full_name: George Macon
        email: ${userEmail}
      cookiecutters_dir: ${config.xdg.cacheHome}/cookiecutter/cookiecutters
      replay_dir: ${config.xdg.cacheHome}/cookiecutter/replay
    '';
    "${config.xdg.configHome}/emacs/init.el".source = ./emacs/init.el;
  };

  home.shellAliases = {
    cat = "${pkgs.bat}/bin/bat";
    ls = "${pkgs.exa}/bin/exa";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Shell
  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "emacs";
    enableSyntaxHighlighting = true;
    envExtra = ''
      export PATH="${config.home.profileDirectory}/bin:$PATH"
    '';
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
    plugins = [{
      name = "fzf-marks";
      src = pkgs.fetchFromGitHub {
        owner = "urbainvaes";
        repo = "fzf-marks";
        rev = "ff3307287bba5a41bf077ac94ce636a34ed56d32";
        hash = "sha256-e6z0ePN0SrMQw/jqTJHPfFSwcLJpd2ZA6kTaj++wdIk=";
      };
    }];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # SSH
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "5m";
    extraOptionOverrides = {
      # Mozilla Cryptography Recommendations
      HostKeyAlgorithms =
        "ssh-ed25519-cert-v01@openssh.com,ssh-ed25519,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp521,ecdsa-sha2-nistp384,ecdsa-sha2-nistp256,ssh-rsa-cert-v01@openssh.com,ssh-rsa";
      KexAlgorithms =
        "curve25519-sha256@libssh.org,ecdh-sha2-nistp521,ecdh-sha2-nistp384,ecdh-sha2-nistp256,diffie-hellman-group-exchange-sha256";
      MACs =
        "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com";
      Ciphers =
        "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";
    };
    includes = [ "host_*.config" ];
  };

  # Git
  programs.git = {
    enable = true;
    aliases = {
      graph = "log --graph --oneline --decorate";
      assume = "update-index --assume-unchanged";
      unassume = "update-index --no-assume-unchanged";
      assumed = "!git ls-files -v | grep ^h | cut -c 3-";
      unassumeall =
        "!git assumed | xargs git update-index --no-assume-unchanged";
      topush = "log @{u}..";
      pushnew = "push -u origin HEAD";
      wip = "commit -anm WIP";
      unwip = ''!test "$(git log --pretty=%s -1)" = WIP && git reset HEAD~'';
    };
    extraConfig = {
      color.ui = "auto";
      diff = {
        algorithm = "histogram";
        compactionHeuristic = true;
      };
      push.default = "simple";
      pull.ff = "only";
      merge = {
        conflictstyle = "diff3";
        tool = "${pkgs.vim}/bin/vimdiff";
      };
      mergetool.prompt = false;
      fetch.fsckObjects = true;
      receive.fsckObjects = true;
      transfer.fsckObjects = true;
      fsck.skipList = "${skiplist}";
      fetch.fsck.skipList = "${skiplist}";
      receive.fsck.skipList = "${skiplist}";
      init.defaultBranch = "main";
    };
    ignores = [ ".direnv/" "*~" "\\#*\\#" ".\\#*" ".dir-locals.el" ];
    lfs.enable = true;
    userEmail = userEmail;
    userName = "George Macon";
  };

  # Emacs
  programs.emacs = {
    enable = true;
    package = pkgs.emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      package = pkgs.emacsPgtk;
      alwaysEnsure = true;
    };
  };
}
