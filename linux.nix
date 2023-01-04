{ config, pkgs, ... }: {
  home.packages = with pkgs; [ ncdu ];
  programs.git.extraConfig.credential.helper = "libsecret";
}
