{ pkgs, ... }: {
  programs.rofi = {
    enable = true;
  };

  home.packages = with pkgs; [
    rofi-power-menu
  ];
}
