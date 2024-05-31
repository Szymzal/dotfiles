{ lib, osConfig, ... }:
with lib;
{
  config = mkIf osConfig.mypackages.games.minecraft.client.enable {
    mypackages.impermanence.directories = [
      ".config/PrismLauncher"
    ];
  };
}
