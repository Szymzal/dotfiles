{
  lib,
  config,
  pkgs,
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

    home.packages = with pkgs; [
      bottles
    ];
  };
}
