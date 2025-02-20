{
  pkgs,
  lib,
  config,
  inputs,
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

    programs = {
      xwayland.enable = true;
      river = {
        enable = true;
        xwayland.enable = true;
      };
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        withUWSM = true;
      };
    };

    mypackages.cachix = {
      substituters = ["https://hyprland.cachix.org"];
      public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    programs.uwsm = {
      enable = true;
    };

    xdg.portal = {
      enable = true;
    };
  };
}
