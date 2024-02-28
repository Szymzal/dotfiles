{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.games.roblox;
in
{
  options = {
    mypackages.games.roblox = {
      enable = mkEnableOption "Enable roblox";
    };
  };

  config = mkIf cfg.enable {
    # TODO: vinegar cannot bulid because one of the patches fail on Hunk #4 at 2758.
    # I have no idea why and how to for example disable all patches for wine
    #
    # environment.systemPackages = with pkgs; [
    #   (vinegar.override (oldVinegar: {
    #     wine = oldVinegar.wine.overrideDeriviation (oldAttrs: {
    #       patches = (oldAttrs.patches or []);
    #     });
    #   }))
    # ];
  };
}
