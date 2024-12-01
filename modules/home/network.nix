{
  lib,
  osConfig,
  ...
}:
with lib; {
  config = mkIf osConfig.mypackages.network.enable {
    # xdg.desktopEntries = {
    #   NetworkManager = {
    #     name = "Network Manager Settings";
    #     genericName = "Network";
    #     exec = "nmtui";
    #     icon = "tdenetworkmanager";
    #     terminal = true;
    #     categories = ["Network"];
    #   };
    # };
  };
}
