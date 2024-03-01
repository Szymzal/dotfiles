{ lib, config, ... }: 
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
  };
}
