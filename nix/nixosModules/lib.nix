{ config, lib, ... }: {
  lib.myLib = rec {
    mkThrow = condition: message:
      (if (condition) then true else throw "${message}");
    mkThrowNull = item: message:
      (mkThrow (item != null) message);
    attrToList = str: lib.strings.splitString "." str;
    getOptionsFromHomeConfigs = configPath: lib.attrsets.mapAttrsToList (name: value: (lib.attrsets.getAttrFromPath (attrToList configPath) value)) config.home-manager.users;
    isEnabledOptionOnHomeConfig = option: (lib.lists.findSingle (value: value) false true (getOptionsFromHomeConfigs option));
  };
}
