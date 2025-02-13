{
  lib,
  config,
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

  config = mkIf cfg.enable {
    mypackages.impermanence = {
      directories = [
        {
          directory = ".local/share/bottles";
          method = "symlink";
        }
      ];
    };

    mypackages.flatpak.packages = [
      "com.usebottles.bottles"
    ];
  };
}
