{
  config,
  pkgs,
  username,
  userEmail,
  homeDirectory,
  inputs,
  ...
}:
let
  ripgreprc = pkgs.writeText "ripgrep.rc" ''
    --smart-case
  '';
  skiplist = pkgs.runCommand "skiplist" { } ''
    cut -f1 ${../config/git/skipList} | sort > $out
  '';
  # From https://github.com/nix-community/nix-direnv#storing-direnv-outside-the-project-directory
  direnvLayoutDirSrc = ''
    direnv_layout_dir() {
      echo -n "${config.xdg.cacheHome}/direnv/layouts/"
      echo -n "$PWD" | ${pkgs.b2sum}/bin/b2sum -l160 | cut -d ' ' -f 1
    }
  '';
  rebuild-fzf-mark = pkgs.writeShellApplication {
    name = "rebuild-fzf-mark";
    runtimeInputs = with pkgs; [
      findutils
      gawk
    ];
    text = ''
      find "${config.home.homeDirectory}/code" -type d -name .git \
        | awk 'BEGIN { FS="/"; OFS="/" } { NF=NF-1; print $NF " : " $0 }' \
        > "${config.xdg.configHome}/fzf-marks/bookmarks"
    '';
  };
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = username;
  home.homeDirectory = homeDirectory;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    agedu
    bat
    cachix
    comma
    cookiecutter
    fd
    gh
    git-absorb
    git-credential-oauth
    httpie
    jq
    mosh
    nil
    nix-init
    nix-output-monitor
    nix-prefetch-github
    nix-tree
    nixfmt-rfc-style
    pandoc
    pushover
    pv
    ripgrep
    shellcheck
    unzip
    vim

    certreq
    gitHelpers
    rebuild-fzf-mark
    rsync-git
    wordle
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  home.sessionVariables = {
    EDITOR = "${pkgs.vim}/bin/vim";
    RIPGREP_CONFIG_PATH = "${ripgreprc}";
    FZF_MARKS_FILE = "${config.xdg.configHome}/fzf-marks/bookmarks";
    SHELL = "${pkgs.zsh}/bin/zsh";
  };

  home.file = {
    "${config.xdg.configHome}/bat/config".text = ''
      --theme="Solarized (light)"
    '';
    "${config.xdg.configHome}/cookiecutter/cookiecutter.yaml".text = ''
      default_context:
        full_name: George Macon
        email: ${userEmail}
      cookiecutters_dir: ${config.xdg.cacheHome}/cookiecutter/cookiecutters
      replay_dir: ${config.xdg.cacheHome}/cookiecutter/replay
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # nix-init
  xdg.configFile."nix-init/config.toml".text = ''
    maintainers = ["gmacon"]
    nixpkgs = "builtins.getFlake \"nixpkgs\""
  '';

  # Shell
  programs.zsh = {
    enable = true;
    autocd = true;
    defaultKeymap = "emacs";
    syntaxHighlighting.enable = true;
    envExtra = ''
      umask 022
      typeset -U path
      path[1,0]=("${config.home.profileDirectory}/bin")
    '';
    history.path = "${config.xdg.dataHome}/zsh/zsh_history";
    initExtra = direnvLayoutDirSrc;
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
        src = inputs.zsh-fzf-marks;
      }
    ];
  };

  programs.starship = {
    enable = true;
    settings = {
      shlvl.disabled = false;
      status.disabled = false;
    };
  };
  home.sessionVariables.STARSHIP_LOG = "error";

  programs.direnv = {
    enable = true;
    config = {
      global = {
        bash_path = "${pkgs.bash}/bin/bash";
        strict_env = true;
      };
    };
    nix-direnv.enable = true;
    stdlib = ''
      ${direnvLayoutDirSrc}
      use_nix_adhoc() {
        direnv_load nix shell "$@" --command $direnv dump
      }
      . ${pkgs.flake_env}/share/flake_env/direnvrc
    '';
  };

  programs.fzf.enable = true;

  programs.nix-index.enable = true;

  programs.eza.enable = true;

  # SSH
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "5m";
    extraOptionOverrides = {
      # Mozilla Cryptography Recommendations
      HostKeyAlgorithms = builtins.concatStringsSep "," [
        "ssh-ed25519-cert-v01@openssh.com"
        "ssh-ed25519"
        "ecdsa-sha2-nistp521-cert-v01@openssh.com"
        "ecdsa-sha2-nistp384-cert-v01@openssh.com"
        "ecdsa-sha2-nistp256-cert-v01@openssh.com"
        "ecdsa-sha2-nistp521"
        "ecdsa-sha2-nistp384"
        "ecdsa-sha2-nistp256"
        "ssh-rsa-cert-v01@openssh.com"
        "ssh-rsa"
      ];
      KexAlgorithms = builtins.concatStringsSep "," [
        "curve25519-sha256@libssh.org"
        "ecdh-sha2-nistp521"
        "ecdh-sha2-nistp384"
        "ecdh-sha2-nistp256"
        "diffie-hellman-group-exchange-sha256"
      ];
      MACs = builtins.concatStringsSep "," [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        "hmac-sha2-512"
        "hmac-sha2-256"
        "umac-128@openssh.com"
      ];
      Ciphers = builtins.concatStringsSep "," [
        "chacha20-poly1305@openssh.com"
        "aes256-gcm@openssh.com"
        "aes128-gcm@openssh.com"
        "aes256-ctr"
        "aes192-ctr"
        "aes128-ctr"
      ];
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
      unassumeall = "!git assumed | xargs git update-index --no-assume-unchanged";
      topush = "log @{u}..";
      pushnew = "push -u origin HEAD";
      wip = "commit -anm WIP";
      unwip = ''!test "$(git log --pretty=%s -1)" = WIP && git reset HEAD~'';
      ab = ''!git absorb --base "$(git merge-base --fork-point origin/main HEAD)"'';
    };
    extraConfig = {
      core.fsmonitor = true;
      color.ui = "auto";
      credential.helper = [
        "cache --timeout 28800" # 8 hours
        "oauth"
      ];
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
    ignores = [
      ".direnv/"
      "*~"
      "\\#*\\#"
      ".\\#*"
      ".dir-locals.el"
      ".DS_Store"
    ];
    lfs.enable = true;
    userEmail = userEmail;
    userName = "George Macon";
  };
}
