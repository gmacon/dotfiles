{ config, pkgs, ... }: {
  home.sessionVariables.LD_LIBRARY_PATH = "${pkgs.sssd}/lib";
  programs.ssh.package = pkgs.openssh_gssapi;
}
