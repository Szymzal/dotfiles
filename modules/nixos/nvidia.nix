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
        kernelParams = ["nvidia_drm.fbdev=1" "nvidia_drm.modeset=1"];
        initrd.kernelModules = ["nvidia" "nvidia_drm" "nvidia_uvm" "nvidia_modeset" "i2c-nvidia_gpu"];
        blacklistedKernelModules = ["nouveau"];
        extraModulePackages = [
          config.boot.kernelPackages.nvidia_x11
        ];
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      # environment.sessionVariables."__EGL_VENDOR_LIBRARY_FILENAMES" = "${config.hardware.nvidia.package}/share/glvnd/egl_vendor.d/10_nvidia.json";

      services.xserver.videoDrivers = ["nvidia"];

      hardware.nvidia = {
        nvidiaSettings = true;
        nvidiaPersistenced = true;
        open = true;
        # Wait until problem with missing resolution modes is fixed
        # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        #   version = "570.195.03";
        #   sha256_64bit = "sha256-1H3oHZpRNJamCtyc+nL+nhYsZfJyL7lgxPUxvXrF3B4=";
        #   sha256_aarch64 = "sha256-o4rgB6vo+Cv90lJywovIyVARRGS3R15zYQUj+f1nzWQ=";
        #   openSha256 = "sha256-vCBB/UJgVKHlSEWdgoF45lODr3YJmR6JwjrwWgWszBw=";
        #   settingsSha256 = "sha256-mjKkMEPV6W69PO8jKAKxAS861B82CtCpwVTeNr5CqUY=";
        #   persistencedSha256 = "sha256-BMpo2PIabhHjZQqUQi/W5DYhgAPmfCdFvXdN6ND2Bfs=";
        # };
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
