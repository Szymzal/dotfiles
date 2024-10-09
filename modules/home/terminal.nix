{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.terminal;
in
{
  options = {
    mypackages.terminal = {
      enable = mkEnableOption "Enable terminal";
    };
  };

  config = mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
    };

    home.sessionVariables = {
      TERMINAL = "foot";
    };

    home.packages = with pkgs; [
      xdg-terminal-exec
    ];
  };
}
