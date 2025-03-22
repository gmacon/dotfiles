{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    xsel
  ];

  programs.firefox = {
    enable = true;
    policies = {
      DisablePocket = true;
    };
  };
}
