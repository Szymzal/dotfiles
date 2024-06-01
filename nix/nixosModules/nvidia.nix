{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.nvidia;
in
{
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
      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      boot.kernelPackages = pkgs.linuxPackages_zen;
      boot.kernelParams = [ "nouveau.config=NvGspRm=1" ];

      environment.systemPackages = with pkgs; [
        mesa
      ];
    })
    (mkIf (!cfg.open.enable) {
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
        # Driver 555 fixes flickering on xwayland
        package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
          version = "555.42.02";
          sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
          sha256_aarch64 = fakeSha256;
          openSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
          settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
          persistencedSha256 = fakeSha256;
        };
      };

      # Sometimes after update "ghost" monitor can appear
      # which breaks Hyprland
      mypackages.monitors = [
        {
          enable = false;
          connector = "Unknown-1";
        }
      ];

      mypackages.unfree.allowed = [
        "nvidia-x11"
      ] ++ lib.optionals config.hardware.nvidia.nvidiaSettings [
        "nvidia-settings"
      ];
    })
  ]);
}
