{ config, pkgs, unstablePkgs, lib, ... }: {
  home.packages = [
    pkgs.slack
    unstablePkgs.zotero_7
  ];
  systemd.user.services.rclone = {
    Unit = {
      Description = "Mount Box with rclone";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "notify";
      ExecStart = lib.concatStringsSep " " [
        "${pkgs.rclone}/bin/rclone"
        "mount"
        "--log-systemd"
        "--vfs-cache-mode=writes"
        "box:"
        "${config.home.homeDirectory}/Box"
      ];
    };
  };
}
