{ pkgs, lib, ... }: {
  system.stateVersion = "23.11";

  networking.hostName = "silicon";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/media" = {
      device = "/dev/sda1";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
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

  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      git
      vim
      wakeonlan
      ;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.openssh.enable = true;

  services.printing = {
    enable = true;
    defaultShared = true;
    drivers = with pkgs; [ brlaser ];
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  hardware.printers.ensurePrinters = [
    {
      name = "home";
      deviceUri = "usb://Brother/HL-L2340D%20series?serial=U63879L5N360763";
      model = "drv:///brlaser.drv/brl2340d.ppd";
      ppdOptions = {
        PageSize = "Letter";
        Duplex = "DuplexNoTumble";
      };
    }
  ];

  # N.B. Tailscale is enabled by the tailscale module
  services.tailscale = {
    useRoutingFeatures = "server";
    extraUpFlags = [ "--advertise-exit-node" ];
  };
}
