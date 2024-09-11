{ lib, config, ... }:
with lib;
let
  myLib = config.lib.myLib;
in
{
  mypackages.unfree.allowed = mkIf ((myLib.isEnabledOptionOnHomeConfig "mypackages.blender.enable") && config.home-manager.useGlobalPkgs) [
    "blender"
    "cuda_cudart"
    "cuda_nvcc"
    "cuda_cccl"
  ];
}
