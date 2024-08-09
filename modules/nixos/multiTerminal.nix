{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.multiTerminal;
in
{
  options = {
    mypackages.multiTerminal = {
      enable = mkEnableOption "Enable multi terminal";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tmux
    ];
  };
}
