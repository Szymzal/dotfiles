{
  lib,
  config,
  osConfig,
  ...
}:
with lib; let
  cfg = config.mypackages.bottles;
in {
  options = {
    mypackages.bottles = {
      enable = mkEnableOption "Enable bottles";
    };
  };

  config = mkIf (osConfig.mypackages.bottles.enable && cfg.enable) {
    mypackages.impermanence = {
      directories = [
        {
          directory = ".local/share/bottles";
          method = "symlink";
        }
      ];
    };
  };
}
