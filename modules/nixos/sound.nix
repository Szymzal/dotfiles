{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.sound;
in {
  options = {
    mypackages.sound = {
      enable = mkEnableOption "Enable sound";
    };
  };

  config = mkIf cfg.enable {
    # NOTE: sound.enable only enables ALSA, but I have Pipewire instead
    # sound.enable = true;

    boot.kernelParams = ["threadirqs"];
    security = {
      rtkit.enable = true;
      pam.loginLimits = [
        {
          domain = "@audio";
          type = "-";
          item = "rtprio";
          value = "90";
        }
      ];
    };

    services = {
      pipewire = {
        enable = true;
        audio.enable = true;
        pulse.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        jack.enable = true;
      };
      udev.extraRules = ''
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
        DEVPATH=="/devices/virtual/misc/hpet", OWNER="root", GROUP="audio", MODE="0660"
      '';
    };

    environment.systemPackages = with pkgs; [
      qpwgraph
      # helvum
      pavucontrol
    ];
  };
}
