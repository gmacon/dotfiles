{
  system.autoUpgrade = {
    enable = true;
    flake = "github:gmacon/dotfiles";
    flags = [ "--accept-flake-config" ];
    randomizedDelaySec = "1h";
    allowReboot = true;
    rebootWindow = {
      lower = "06:00";
      upper = "08:00";
    };
    # Note: This must be during the reboot window for the reboot to happen.
    dates = "06:00";
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    randomizedDelaySec = "1h";
    options = "--delete-older-than 30d";
  };
}
