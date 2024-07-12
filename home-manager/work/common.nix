{ config, pkgs, ... }: {
  home.packages = builtins.attrValues {
    inherit (pkgs)
      acsaml
      rclone
      tmux
      ;
  };

  # Vagrant
  home.file."${config.home.homeDirectory}/.vagrant.d/Vagrantfile".source = ../config/Vagrantfile;
}
