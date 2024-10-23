{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.nvidia;
in {
  options = {
    mypackages.nvidia = {
      enable = mkEnableOption "Enable support for NVIDIA GPUs";
      open = {
        enable = mkEnableOption "Enable open source drivers (NVK)";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.open.enable {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      boot.kernelPackages = pkgs.linuxPackages_zen;
      boot.kernelParams = ["nouveau.config=NvGspRm=1"];

      environment.systemPackages = with pkgs; [
        mesa
      ];
    })
    (mkIf (!cfg.open.enable) {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };

      # Sometimes after update "ghost" monitor can appear
      # which breaks Hyprland
      mypackages.monitors = [
        {
          enable = false;
          connector = "Unknown-1";
        }
      ];

      mypackages.unfree.allowed =
        [
          "nvidia-x11"
        ]
        ++ lib.optionals config.hardware.nvidia.nvidiaSettings [
          "nvidia-settings"
        ];
    })
  ]);
}
