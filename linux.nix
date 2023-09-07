{ pkgs, ... }: {
  home.packages = with pkgs; [
    htop
    ncdu
  ];
}
