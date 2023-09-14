{ pkgs, ... }: {
  targets.genericLinux.enable = true;
  programs.bash.enable = true;

  home.packages = with pkgs; [
    htop
    ncdu
  ];
}
