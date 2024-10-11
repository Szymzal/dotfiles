{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.casparcg-client;
in
{
  options = {
    mypackages.casparcg-client = {
      enable = mkEnableOption "Enable CasparCG Client";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      casparcg-client
    ];

    mypackages.impermanence.directories = [
      ".CasparCG"
    ];
  };
}
