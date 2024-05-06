{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.nvidia;
in
{
  options = {
    mypackages.nvidia = {
      enable = mkEnableOption "Enable support for NVIDIA GPUs";
    };
  };

  config = mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };

    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    # Sometimes after update "ghost" monitor can appear
    # which breaks Hyprland
    mypackages.monitors = [
      {
        enable = false;
        spec = {
          connector = "Unknown-1";
        };
      }
    ];

    mypackages.unfree.allowed = [
      "nvidia-x11"
    ] ++ lib.optionals config.hardware.nvidia.nvidiaSettings [
      "nvidia-settings"
    ];
  };
}
