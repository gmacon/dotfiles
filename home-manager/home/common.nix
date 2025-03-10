{ pkgs, unstablePkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      beeper
      beeper-bridge-manager
      calibre
      genopro
      gnome-tweaks
      gnucash
      libreoffice
      mpv
      nixpkgs-review
      thunderbird
      yt-dlp
      zoom-us
      ;
    inherit (unstablePkgs) cwtch-ui;
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
