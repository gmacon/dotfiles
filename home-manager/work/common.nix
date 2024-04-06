{ config, pkgs, ... }: {
  home.packages = [ pkgs.rclone ];

  # Vagrant
  home.file."${config.home.homeDirectory}/.vagrant.d/Vagrantfile".source = ../config/Vagrantfile;
}
