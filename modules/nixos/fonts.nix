{ pkgs, lib, config, ... }: 
with lib;
let
  cfg = config.mypackages.fonts;
in
{
  options = {
    mypackages.fonts = {
      enable = mkEnableOption "Enable fonts";
    };
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
    ];
  };
}
