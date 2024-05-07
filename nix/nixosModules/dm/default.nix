{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.mypackages.dm;
in
{
  options = {
    mypackages.dm = {
      enable = mkEnableOption "Enable Display Manager";
    };
  };

  config = mkIf cfg.enable {
    mypackages.wm.enable = mkForce true;

    # systemd.tmpfiles.rules = let
    #   monitorConfigs = lib.concatStrings (lib.forEach config.mypackages.monitors (value: if (value.enable) then ''
    #     <logicalmonitor>
    #       <x>${builtins.toString value.position.x}</x>
    #       <y>${builtins.toString value.position.y}</y>
    #       <scale>${builtins.toString value.mode.scale}</scale>
    #       <primary>${if (value.primary) then "yes" else "no"}</primary>
    #       <monitor>
    #         <monitorspec>
    #           <connector>${value.spec.connector}</connector>
    #           <vendor>${value.spec.vendor}</vendor>
    #           <product>${value.spec.model}</product>
    #           <serial>${value.spec.serial}</serial>
    #         </monitorspec>
    #         <mode>
    #           <width>${builtins.toString value.mode.width}</width>
    #           <height>${builtins.toString value.mode.height}</height>
    #           <rate>${builtins.toString value.mode.rate}</rate>
    #         </mode>
    #       </monitor>
    #     </logicalmonitor>
    #   '' else ""));
    #   generatedConfig = ''
    #     <monitors version="2">
    #     <configuration>
    #     ${monitorConfigs}</configuration>
    #     </monitors>
    #   '';
    #   monitorsConfig = pkgs.writeText "gdm_monitors.xml" generatedConfig;
    # in
    # [
    #   "L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}"
    # ];

    services.xserver = {
      enable = true;
      xkb.layout = "pl";
      # displayManager.gdm.enable = true;
      # displayManager.gdm.wayland = true;
    };

    services.greetd =
    let
      configFile = pkgs.writeText "hyprland.conf" ''
        exec-once = ${config.programs.regreet.package}/bin/regreet; hyprctl dispatch exit
      '';
    in
    {
      enable = true;
      settings.default_session.command = "${config.programs.hyprland.package}/bin/Hyprland --config ${configFile}";
    };

    programs.regreet.enable = true;
  };
}
