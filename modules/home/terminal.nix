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
    programs.kitty = {
      enable = true;
    };

    home.sessionVariables = {
      TERMINAL = "kitty";
    };

    home.packages = with pkgs; [
      xdg-terminal-exec
    ];
  };
}
