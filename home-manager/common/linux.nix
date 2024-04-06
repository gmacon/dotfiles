{ pkgs, ... }: {
  targets.genericLinux.enable = true;
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      umask 022
    '';
  };

  home.packages = with pkgs; [
    htop
    dua
  ];
}
