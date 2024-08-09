{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.unfree;
in
{
  options = {
    mypackages.unfree = {
      allowed = mkOption {
        default = [];
        example = [ "obsidian" "intelephense" ];
        description = "Name of packages which are allowed to be installed even with unfree licence";
        type = types.listOf types.str;
      };
    };
  };

  config = {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (getName pkg) cfg.allowed;
  };
}
