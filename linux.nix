{ config, pkgs, ... }: {
  home.packages = with pkgs; [ ncdu ];
  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "Fira Code Nerd Font";
      font.size = 10.0;
      draw_bold_text_with_bright_colors = true;
      key_bindings = [
        { key = "N"; mods = "Shift|Control"; action = "SpawnNewInstance"; }
      ];
    };
  };
}
