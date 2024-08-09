{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.find;
in
{
  options = {
    mypackages.find = {
      enable = mkEnableOption "Enable find replacement";
    };
  };

  config = mkIf cfg.enable {
    programs.fd.enable = true;
  };
}
