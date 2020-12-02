# Dependencies

Dependencies and source for Arch, Debian, macOS

- atool: pacman, apt, brew
- direnv: aur, apt, brew
- emacs: pacman, source, Emacs.app
- fd: pacman, ..., brew
- Fira Code: otf-fira-code, apt fonts-firacode, https://github.com/tonsky/FiraCode
- firefox: pacman, apt, <https://www.firefox.com>
- fzf: pacman, [GitHub releases](https://github.com/junegunn/fzf-bin/releases), brew
- git-lfs, aur, apt, brew
- git: pacman, ppa:git-core/ppa, builtin  (Note: need Git >= 2.20)
- httpie: pacman, apt, brew
- mosh: pacman, apt, brew
- openssh: pacman, apt, builtin
- pass: pacman, apt, brew
- pinentry: pacman, apt pinentry-qt, brew pinentry-mac
- pyenv: git, (use deadsnakes instead), brew
- ripgrep: pacman, [deb from GitHub](https://github.com/BurntSushi/ripgrep/releases), brew
- rustup: <https://sh.rustup.rs>
- thunderbird: pacman, apt, <https://www.thunderbird.net>
- zsh: pacman, apt, builtin

# Linux-only Dependencies

Dependencies and source for Arch, Debian

- alacritty: pacman, git via cargo-deb
- brightnessctl: aur, don't know \[1\]
- hexchat: pacman, apt
- pamixer: pacman, git
- sxlock: aur sxlock-git, git
- xss-lock: pacman, apt
- dunst: pacman, apt
- xcape: pacman, apt
- gnome-keyring: pacman, apt

# Build from my repos (only on Linux)

- dmenu
- dwm
- dwmstatus

Build deps (Debian):

- libboost-program-options-dev
- libpam0g-dev
- libpulse-dev
- libsensors4-dev
- libx11-dev
- libxext-dev
- libxinerama-dev
- libxrandr-dev

# Notes

\[1\]: my Debian machine doesn't have a variable-brightness screen
