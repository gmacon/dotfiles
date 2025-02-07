{ config, pkgs, ... }:
{
  targets.genericLinux.enable = true;
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      umask 022
    '';
    profileExtra = ''
      if [[ -e ${config.xdg.stateHome}/hm-activation-stamp ]]; then
        activation_age=$(($(date +%s) - $(stat -c %Y -- ${config.xdg.stateHome}/hm-activation-stamp)))
        if [[ $activation_age > 604800 ]]; then
          echo "Home Manager last activated $(($activation_age / 86400)) days ago."
        fi
        unset activation_age
      fi
    '';
  };

  home.packages = with pkgs; [
    htop
    dua
  ];
}
