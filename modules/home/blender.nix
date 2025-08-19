{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.blender;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
  };
in {
  options = {
    mypackages.blender = {
      enable = mkEnableOption "Enable Blender";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
      (blender.override {jackaudioSupport = true;})
    ];

    mypackages.impermanence.directories = [
      ".config/blender"
    ];
  };
}
