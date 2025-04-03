{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.packages = [
    pkgs.slack
    pkgs.vistafonts
    pkgs.zotero-gtri
  ];

  home.sessionVariables = {
    "SSH_AUTH_SOCK" = "${config.home.homeDirectory}/.1password/agent.sock";
  };

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
