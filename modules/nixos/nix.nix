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
      flake-path = mkOption {
        default = null;
        example = "/persist/nixos";
        description = "path to flake";
        type = types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    programs.nh = {
      enable = true;
    };

    environment = {
      sessionVariables = {
        FLAKE = cfg.flake-path;
      };
      systemPackages = with pkgs; [
        nvd
        nix-output-monitor
      ];
    };
  };
}
