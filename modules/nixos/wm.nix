{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.wm;
in {
  options = {
    mypackages.wm = {
      enable = mkEnableOption "Enable Window Manager";
    };
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;

    mypackages.way-displays.enable = mkDefault true;

    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      xwaylandvideobridge
    ];

    programs.river = {
      enable = true;
      xwayland.enable = true;
      extraPackages = with pkgs; [
        hyprlock
      ];
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
