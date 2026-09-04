{
  lib,
  osConfig,
  ...
}:
with lib; {
  config = mkIf (osConfig.mypackages.games.minecraft.client.java.enable || osConfig.mypackages.games.minecraft.client.bedrock.enable) {
    mypackages.impermanence.directories = optionals osConfig.mypackages.games.minecraft.client.java.enable [
      ".local/share/PrismLauncher"
      "speedrunigt"
    ];

    mypackages.flatpak.packages = optionals osConfig.mypackages.games.minecraft.client.bedrock.enable [
      "io.mrarm.mcpelauncher"
    ];
  };
}
