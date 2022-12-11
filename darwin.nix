{ config, pkgs, ... }: {
  home.file = {
    "Library/Application Support/iTerm2/Scripts/autotheme.py".source =
      ./iterm2/autotheme.py;
  };
}
