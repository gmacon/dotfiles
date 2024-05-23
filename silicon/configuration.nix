{
  system.stateVersion = "23.11";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  users = {
    mutableUsers = false;
    users.gmacon = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$y$j9T$vwSIMTVSGgJr6KG1M73Jk1$yXm2putCiYVFPbyHFwGzjYuiGL6fmIauW7QStmqSh7A";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF36+cqktTA1bjjg8/Q2j/CvftsE866fHT+XOji9rqCi"
      ];
    };
  };

  services.jellyfin.enable = true;
}
