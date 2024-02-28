{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.games.minecraft;
in
{
  options = {
    mypackages.games.minecraft = {
      enable = mkEnableOption "Enable Minecraft";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
    ];

    # TODO: minecraft servers
  };
}
