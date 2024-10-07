{ pkgs, lib, config, ... }: 
with lib;
let
  cfg = config.mypackages.sound;
in
{
  options = {
    mypackages.sound = {
      enable = mkEnableOption "Enable sound";
    };
  };

  config = mkIf cfg.enable {
    # NOTE: sound.enable only enables ALSA, but I have Pipewire instead
    # sound.enable = true;

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
    };

    environment.systemPackages = with pkgs; [
      qpwgraph
      # helvum
      pavucontrol
    ];
  };
}
