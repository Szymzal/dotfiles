{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.games.terraria;
in {
  options = {
    mypackages.games.terraria = {
      enable = mkEnableOption "Enable Terraria";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dotnetCorePackages.sdk_8_0_3xx
    ];

    mypackages.impermanence.directories = [
      {
        directory = ".local/share/Terraria";
        method = "symlink";
      }
    ];
  };
}
