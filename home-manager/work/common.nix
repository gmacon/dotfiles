{ config, pkgs, ... }: {
  home.packages = builtins.attrValues {
    inherit (pkgs)
      rclone
      acsaml
      ;
  };

  # Vagrant
  home.file."${config.home.homeDirectory}/.vagrant.d/Vagrantfile".source = ../config/Vagrantfile;
}
