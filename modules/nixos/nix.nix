{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.nix-helpers;
in {
  options = {
    mypackages.nix-helpers = {
      enable = mkEnableOption "Enable nix helpers";
    };
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
    };

    environment = {
      sessionVariables = {
        FLAKE = "/persist/nixos";
      };
      systemPackages = with pkgs; [
        nvd
        nix-output-monitor
      ];
    };
  };
}
