{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.gc;
in
{
  options = {
    mypackages.gc = {
      enable = mkEnableOption "Enable gc for nix";
    };
  };

  config = mkIf cfg.enable {
    nix.settings.auto-optimise-store = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
