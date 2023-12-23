{ pkgs, ... }: {
  home.packages = with pkgs; [
    yt-dlp
  ];

  services.syncthing.enable = true;
}
