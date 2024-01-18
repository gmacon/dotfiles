{ pkgs, ... }: {
  home.packages = with pkgs; [
    yt-dlp
    zoom-us
  ];

  services.syncthing.enable = true;
}
