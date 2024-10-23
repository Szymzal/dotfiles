{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.home-manager;
in {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  options = {
    mypackages.home-manager = {
      enable = mkEnableOption "Enable home-manager";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      home-manager
    ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs;
      };
    };
  };
}
