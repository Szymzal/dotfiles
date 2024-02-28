{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.games.rocket-league;
in
{
  options = {
    mypackages.games.rocket-league = {
      enable = mkEnableOption "Enable Rocket League BakkesMod";
    };
  };

  config = mkIf cfg.enable {
    mypackages.steam.enable = true;

    # TODO: BakkesMod
    # environment.systemPackages = with pkgs; [
    #   protontricks
    # ];
  };
}
