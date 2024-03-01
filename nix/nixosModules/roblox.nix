{ lib, config, pkgs, ... }:
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

  # Roblox player does not work (anti-cheat will block)
  # And Vinegar doesn't work with wine 9.3, because patches are for 9.2
  config = mkIf cfg.enable {
    # TODO: vinegar cannot bulid because one of the patches fail on Hunk #4 at 2758.
    # I have no idea why and how to for example disable all patches for wine

    # nixpkgs.overlays = [
    #   (final: prev: {
    #     vinegar = prev.vinegar.overrideAttrs (prevAttrs: {
    #       wine = prev.wineWowPackages.staging.overrideDerivation (oldAttrs:
    #       let
    #         vinepatches = lib.debug.traceVal oldAttrs.patches;
    #       in
    #       {
    #         patches = vinepatches;
    #       });
    #     });
    #   })
    # ];

    # environment.systemPackages = with pkgs; [
    #   vinegar
    # ];

    # environment.systemPackages = with pkgs; [
    #   (wineWowPackages.staging.overrideDeriviation (oldAttrs: {
    #     patches = (oldAttrs.patches or [])
    #     ++ [
    #
    #     ];
    #   }))
    # ];

    # environment.systemPackages = with pkgs; [
    #   (vinegar.override (oldVinegar: {
    #     wine = oldVinegar.wine.overrideDeriviation (oldAttrs: {
    #       patches = (oldAttrs.patches or []);
    #     });
    #   }))
    # ];
  };
}
