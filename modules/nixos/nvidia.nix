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

      boot.kernelParams = ["nouveau.config=NvGspRm=1"];

      environment.systemPackages = with pkgs; [
        mesa
      ];

      mypackages.cuda.enable = mkForce false;
    })
    (mkIf (!cfg.open.enable) {
      boot = {
        kernelParams = ["nvidia_drm.fbdev=1"];
        initrd.kernelModules = ["nvidia" "nvidiafb" "nvidia_drm" "nvidia_uvm" "nvidia_modeset" "i2c-nvidia_gpu"];
        blacklistedKernelModules = ["nouveau"];
        extraModulePackages = [
          config.boot.kernelPackages.nvidia_x11
        ];
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      environment.sessionVariables."__EGL_VENDOR_LIBRARY_FILENAMES" = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";

      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        nvidiaSettings = true;
        nvidiaPersistenced = true;
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.latest;
      };

      # Sometimes after update "ghost" monitor can appear
      mypackages.monitors.config = [
        {
          enable = false;
          connector = "!Unknown-*";
        }
      ];

      mypackages.unfree.allowed =
        [
          "nvidia-x11"
          "nvidia-persistenced"
        ]
        ++ lib.optionals config.hardware.nvidia.nvidiaSettings [
          "nvidia-settings"
        ];
    })
  ]);
}
