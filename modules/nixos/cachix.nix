{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.cachix;
in {
  options = {
    mypackages.cachix = {
      enable = mkEnableOption "Enable Cachix";
      substituters = mkOption {
        default = [];
        example = ["https://hyprland.cachix.org"];
        description = "List of substituters to get from";
        type = types.listOf types.str;
      };
      public-keys = mkOption {
        default = [];
        example = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        description = "Trusted public keys to ensure safety of downloaded files";
        type = types.listOf types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    nix.settings = {
      substituters = cfg.substituters;
      trusted-public-keys = cfg.public-keys;
    };
  };
}
