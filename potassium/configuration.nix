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
    archives.potassium-srv = {
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

  # Syncthing Server
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings = {
      devices = {
        argon.id = "ICCESTD-KVAK72C-5KNA662-A664RNG-7L24NWB-H3SQFTC-7TDIRLY-QHP7EQL";
        phosphorous.id = "ATK67KF-7K5FEWT-TDCLGNK-5OA3WFP-ERNHUL3-KK3GB4A-ODD6BES-UDCIOA5";
        laptop.id = "P3QWTGO-O75MDRX-TIAFVIO-ZHAG4YP-5ECWGAA-35I44T2-LFHSC5M-B2US6QS";
      };
      folders = {
        "/srv/syncthing/whelchel_reunion" = {
          id = "hb2tz-zl3vr";
          devices = [
            "argon"
            "phosphorous"
            "laptop"
          ];
        };
      };
    };
  };
}
