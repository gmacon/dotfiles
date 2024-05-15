{ config, ... }: {
  system.stateVersion = "23.11";
  fileSystems."/srv" = {
    device = "/dev/disk/by-id/scsi-0DO_Volume_volume-nyc3-01";
    options = [ "discard" "nofail" "noatime" ];
  };
  services.openssh.ports = [ 46409 ];

  # Backups
  age.secrets.tarsnapKey.file = ../secrets/tarsnap-k.key.age;
  services.tarsnap = {
    enable = true;
    keyfile = config.age.secrets.tarsnapKey.path;
    archives.argon-home = {
      directories = [ "/srv" ];
      checkpointBytes = "10G";
      period = "daily";
      excludes = [
        "archive"
        "lost+found"
      ];
      tarsnapper = {
        enable = true;
        deltas = "1d 7d 28d 364d";
      };
    };
  };
}
