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

  config = mkIf cfg.enable (let
  in {
    security.polkit.enable = true;

    mypackages.way-displays.enable = mkDefault true;

    programs.xwayland.enable = true;

    environment.systemPackages = with pkgs; [
      xwaylandvideobridge
    ];

    programs.river = {
      enable = true;
      xwayland.enable = true;
    };

    systemd = {
      user.extraConfig = ''
        DefaultEnvironment="PATH=/run/wrappers/bin:/etc/profiles/per-user/%u/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"
      '';
    };

    # TODO: Why
    services.displayManager.sessionPackages = mkForce [ ];
    programs.uwsm = {
      enable = true;
      waylandCompositors = {
        river = {
          prettyName = "River";
          comment = "River compositor managed by UWSM";
          binPath = "/run/current-system/sw/bin/river";
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
  });
}
