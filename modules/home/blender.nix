{
  lib,
  config,
  pkgs,
  inputs,
  osConfig,
  ...
}:
with lib; let
  cfg = config.mypackages.blender;
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };
in {
  options = {
    mypackages.blender = {
      enable = mkEnableOption "Enable Blender";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs-unstable; [
      (blender.override {
        # jackaudioSupport = true;
        cudaSupport = osConfig.mypackages.nvidia.enable;
      })
    ];

    mypackages.impermanence.directories = [
      ".config/blender"
    ];
  };
}
