{ pkgs, ... }: {
  home.packages = with pkgs; [ hello ];
  # programs.hyprland.enable = true;
}
