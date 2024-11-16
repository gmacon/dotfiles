{ pkgs, unstablePkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      calibre
      cwtch-ui
      genopro
      gnucash
      libreoffice
      mpv
      thunderbird
      yt-dlp
      zoom-us
      ;
    inherit (pkgs.gnome) gnome-tweaks;
    inherit (unstablePkgs) beeper;
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.password-store.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };

  services.syncthing.enable = true;

  programs.git = {
    package = pkgs.gitFull;
    extraConfig.sendemail = {
      smtpserver = "smtp.fastmail.com";
      smtpuser = "george@kj4jzy.org";
      smtpencryption = "ssl";
      smtpserverport = 465;
    };
  };
}
