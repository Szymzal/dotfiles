{
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.disko;
in {
  imports = [
    inputs.disko.nixosModules.disko
  ];

  options.mypackages.disko = {
    enable = mkEnableOption "Enable disko";
    devices = mkOption {
      type = types.attrs;
      description = "List of disks to format";
    };
  };

  config = mkIf cfg.enable {
    disko.devices = cfg.devices;
  };
}
