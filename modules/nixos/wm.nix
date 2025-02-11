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

    # systemd = {
    #   user.extraConfig = ''
    #     DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"
    #   '';
    # };

    # TODO: Why
    # services.displayManager.sessionPackages = mkForce [ ];
    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        river = {
          prettyName = "River";
          comment = "River compositor managed by UWSM";
          binPath = "${config.programs.river.package}/share/wayland-sessions/river.desktop";
        };
      };
    };

    xdg.portal = {
      enable = true;
      wlr = {
        enable = true;
        settings = {
          screencast = {
            output_name = "DP-1";
            max_fps = 30;
            exec_before = "";
            exec_after = "";
            chooser_type = "dmenu";
            chooser_cmd = "${lib.getExe pkgs.fuzzel} --dmenu";
          };
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
