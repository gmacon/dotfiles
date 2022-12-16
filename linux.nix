{ config, pkgs, ... }: {
  programs.git.extraConfig.credential.helper = "libsecret";
}
