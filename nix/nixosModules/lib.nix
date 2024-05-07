{ config, lib, ... }: {
  lib.myLib = rec {
    mkThrow = condition: message:
      (if (condition) then true else throw "${message}");
    mkThrowNull = item: message:
      (mkThrow (item != null) message);
    attrToList = str: lib.strings.splitString "." str;
    getOptionsFromHomeConfigs = configPath: lib.attrsets.mapAttrsToList (name: value: (lib.attrsets.getAttrFromPath (attrToList configPath) value)) config.home-manager.users;
    isEnabledOptionOnHomeConfig = option: (lib.lists.findSingle (value: value) false true (getOptionsFromHomeConfigs option));
    hyprlandMonitorsConfig = (lib.forEach (config.mypackages.monitors) (value:
      if (value.enable) then
        "${value.spec.connector},${builtins.toString value.mode.width}x${builtins.toString value.mode.height}@${builtins.toString value.mode.rate},${builtins.toString value.position.x}x${builtins.toString value.position.y},${builtins.toString value.mode.scale}"
      else
        "${value.spec.connector},disable"
      )
    );
    getPrimaryMonitor = (builtins.head (builtins.filter (value: (value.enable && value.primary)) config.mypackages.monitors));
  };
}
