{ inputs, lib, config, osConfig, ... }:
with lib;
let
  osCfg = osConfig.mypackages.impermanence;
  cfg = config.mypackages.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options = {
    mypackages.impermanence = {
      enable = mkEnableOption "Enable impermanence";
      persistent-path = mkOption {
        default = "${osCfg.persistenceDir}/home";
        example = "/persist/home/szymzal";
        description = "Path to persist all folders";
        type = types.str;
      };
      directories = mkOption {
        default = [];
        example = [ "Downloads" "dev/project" ];
        description = "Directories to persist. Directories will be appended to persistent-path option";
        type = types.listOf types.str;
      };
      files = mkOption {
        default = [];
        example = [ ".zshrc" ".ssh/id_rsa" ];
        description = "Files to persist. File paths will be appended to persistent-path option";
        type = types.listOf types.str;
      };
    };
  };

  config = mkIf (cfg.enable && osCfg.enable) {
    home.persistence."${cfg.persistent-path}" = {
      directories = cfg.directories;
      files = cfg.files;
      allowOther = true;
    };
  };
}
