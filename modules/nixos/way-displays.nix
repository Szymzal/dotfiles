{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mypackages.way-displays;
in {
  options = {
    mypackages.way-displays = {
      enable = mkEnableOption "Enable output managment";
    };
  };

  config = mkIf (cfg.enable) {
    systemd.user.services.way-displays = {
      enable = true;

      unitConfig = {
        Description = "Output configuration";
        After = ["river-session.target"];
        PartOf = ["river-session.target"];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.way-displays}/bin/way-displays";
        Restart = "always";
      };

      bindsTo = ["river-session.target"];
    };

    systemd.services.way-displays = {
      enable = true;

      unitConfig = {
        Description = "Output configuration";
        After = ["greetd.service"];
        PartOf = ["greetd.service"];
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.way-displays}/bin/way-displays";
        Restart = "always";
      };

      bindsTo = ["graphical.target"];
    };

    environment.etc = {
      "way-displays/cfg.yaml".text = ''
        ARRANGE: ROW
        ALIGN: MIDDLE
        ORDER:
          - 'DP-1'
          - 'HDMI-A-1'
        MODE:
          - NAME_DESC: '27G2G4'
            WIDTH: 1920
            HEIGHT: 1080
            HZ: 144
          - NAME_DESC: 'PL2470H'
            WIDTH: 1920
            HEIGHT: 1080
            HZ: 144
        VRR_OFF:
          - '27G2G4'
          - 'PL2470H'
        DISABLED:
          - 'Unknown-*'
      '';
    };
  };
}
