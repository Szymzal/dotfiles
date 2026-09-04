{
  lib,
  osConfig,
  ...
}:
with lib; {
  config = mkIf osConfig.mypackages.ghidra.enable {
    mypackages.impermanence.directories = [".config/ghidra"];
  };
}
