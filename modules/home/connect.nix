{
  lib,
  osConfig,
  ...
}:
with lib; {
  config = mkIf osConfig.mypackages.connect.enable {
    services.kdeconnect.enable = true;

    mypackages.impermanence.directories = [
      ".config/kdeconnect"
    ];
  };
}
