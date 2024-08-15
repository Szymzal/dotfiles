{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.godot;
in
{
  options = {
    mypackages.godot = {
      enable = mkEnableOption "Enable Godot engine";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      godot_4
    ];

    mypackages.impermanence.directories = [
      
    ];
  };
}
