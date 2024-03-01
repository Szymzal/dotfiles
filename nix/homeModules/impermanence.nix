{ inputs, lib, config, ... }:
with lib;
let
  cfg = config.mypackages.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  options = {
    mypackages.impermanence = {
      enable = mkEnableOption "Enable impermanence";
    };
  };

  config = mkIf cfg.enable {
    # TODO: finish it
  };
}
