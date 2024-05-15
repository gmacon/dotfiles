{
  system.stateVersion = "23.11";
  fileSystems."/srv" = {
    device = "/dev/disk/by-id/scsi-0DO_Volume_volume-nyc3-01";
    options = [ "discard" "nofail" "noatime" ];
  };
  services.openssh.ports = [ 46409 ];
}
