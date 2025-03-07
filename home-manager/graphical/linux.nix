{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wl-clipboard
    xsel
  ];

  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.resistFingerprinting" = false;
      "webgl.disabled" = false;
    };
  };
}
