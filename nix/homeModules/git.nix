{ lib, config, ... }: 
with lib;
let
  cfg = config.mypackages.git;
in
{
  options = {
    mypackages.git = {
      enable = mkEnableOption "Enable git";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;

      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
