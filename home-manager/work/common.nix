{ pkgs, ... }:
{
  home.packages = builtins.attrValues { inherit (pkgs) acsaml rclone; };
}
