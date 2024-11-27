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
        wireplumber = {
          enable = true;
        };
        extraConfig = {
          pipewire."92-dont-scratch" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.quantum" = 2048;
              "default.clock.min-quantum" = 1024;
              "default.clock.max-quantum" = 4096;
            };
          };
        };
      };
      udev.extraRules = ''
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
        DEVPATH=="/devices/virtual/misc/hpet", OWNER="root", GROUP="audio", MODE="0660"
      '';
    };

    environment.systemPackages = with pkgs; [
      qpwgraph
      pavucontrol
    ];
  };
}
