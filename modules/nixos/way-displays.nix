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

  config = mkIf cfg.enable {
    systemd.user.services.way-displays = {
      enable = true;

      unitConfig = {
        Description = "Output configuration";
        StopWhenUnneeded = true;
        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.way-displays}/bin/way-displays";
        Restart = "always";
      };

      wantedBy = ["graphical-session.target"];
    };

    environment.etc = {
      "way-displays/cfg.yaml".text =
        ''
          ARRANGE: ROW
          ALIGN: MIDDLE
        ''
        + optionalString (config.mypackages.monitors.order != [])
        ''
          ORDER:
        ''
        + (lib.concatStrings (lib.forEach config.mypackages.monitors.order (
          value: ''
            - '${value}'
          ''
        )))
        + optionalString (config.mypackages.monitors.config != [])
        ''
          MODE:
        ''
        + (lib.concatStrings (lib.forEach config.mypackages.monitors.config (
          value:
            if value.enable
            then ''
              - NAME_DESC: '${value.model}'
                WIDTH: ${builtins.toString value.mode.width}
                HEIGHT: ${builtins.toString value.mode.height}
                HZ: ${builtins.toString value.mode.rate}
            ''
            else ""
        )))
        + optionalString (config.mypackages.monitors.config != [])
        ''
          VRR_OFF:
        ''
        + (lib.concatStrings (lib.forEach config.mypackages.monitors.config (
          value:
            if value.enable
            then ''
              - '${value.model}'
            ''
            else ""
        )))
        + optionalString (config.mypackages.monitors.config != [])
        ''
          DISABLED:
        ''
        + (lib.concatStrings (lib.forEach config.mypackages.monitors.config (
          value:
            if (!value.enable)
            then ''
              - '${value.connector}'
            ''
            else ""
        )));
    };
  };
}
