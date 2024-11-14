{
  lib,
  osConfig,
  ...
}:
with lib; {
  config = mkIf osConfig.mypackages.localsend.enable {
    mypackages.impermanence.directories = [".local/share/org.localsend.localsend_app"];
  };
}
