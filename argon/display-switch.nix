{ pkgs, lib, ... }:
let
  username = "gmacon";
in
{
  hardware.i2c.enable = true;
  home-manager.users.${username} = {
    xdg.configFile."display-switch/display-switch.ini".text = ''
      usb_device = "2516:0004"
      on_usb_connect = "Hdmi1"
    '';
    systemd.user.services.display-switch = {
      Unit.Description = "Display switch via USB switch";
      Service = {
        ExecStart = lib.getExe pkgs.display-switch;
        Type = "simple";
        StandardOutput = "journal";
        Restart = "always";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
