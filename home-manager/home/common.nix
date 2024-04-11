{ pkgs, unstablePkgs, inputs, ... }: {
  home.packages = builtins.attrValues {
    inherit (pkgs)
      calibre
      cwtch
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

  programs.password-store.enable = true;
  services.gpg-agent.enable = true;

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

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "Fira Code Nerd Font";
      font.size = 13.0;
      draw_bold_text_with_bright_colors = true;
      key_bindings = [
        { key = "N"; mods = "Shift|Control"; action = "SpawnNewInstance"; }
      ];
      "import" = [
        "${inputs.alacritty-theme-penumbra}/penumbra-light.yml"
      ];
    };
  };

}
