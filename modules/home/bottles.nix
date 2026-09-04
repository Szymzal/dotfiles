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
        ".local/share/bottles"
      ];
    };

    home.packages = with pkgs; [
      bottles
    ];
  };
}
