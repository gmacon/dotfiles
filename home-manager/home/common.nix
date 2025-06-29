{ pkgs, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      audacity
      beeper
      beeper-bridge-manager
      cwtch-ui
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
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  programs.password-store.enable = true;
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
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

  programs.firefox = {
    enable = true;
    policies = {
      DisablePocket = true;
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.ungoogled-chromium;
  };
}
