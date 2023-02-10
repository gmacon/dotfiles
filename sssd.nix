{ config, pkgs, ... }: {
  home.sessionVariables.LD_LIBRARY_PATH = "${pkgs.sssd}/lib";
}
