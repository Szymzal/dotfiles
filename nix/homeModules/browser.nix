{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.browser;
in
{
  options = {
    mypackages.browser = {
      enable = mkEnableOption "Enable browser";
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
    };

    mypackages.impermanence = {
      directories = [
        ".mozilla"
      ];
    };
  };
}
