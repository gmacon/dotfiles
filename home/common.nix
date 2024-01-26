{ pkgs, ... }: {
  home.packages = with pkgs; [
    thunderbird
    yt-dlp
    zoom-us
  ];

  services.syncthing.enable = true;
}
