{ config, pkgs, ... }: {
  home.packages = with pkgs; [ rclone ];
  systemd.user.services.rclone = {
    Unit = {
      Description = "Mount Box with rclone";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${pkgs.rclone}/bin/rclone mount --vfs-cache-mode full box: ${config.home.homeDirectory}/Box";
    };
  };
}
