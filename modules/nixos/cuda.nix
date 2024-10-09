{ config, lib, ... }:
with lib;
let
  cfg = config.mypackages.cuda;
in
{
  options = {
    mypackages.cuda = {
      enable = mkEnableOption "Enable CUDA support";
    };
  };

  config = mkIf cfg.enable {
    mypackages.unfree.allowed = [
      "cuda_cudart"
      "cuda_nvcc"
      "cuda_cccl"
      "libnpp"
      "libcublas"
      "libcufft"
    ];

    # FIX: https://nixpk.gs/pr-tracker.html?pr=339619
    nixpkgs.config.cudaSupport = true;

    mypackages.cachix = {
      substituters = [ "https://cuda-maintainers.cachix.org" ];
      public-keys = [ "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E=" ];
    };
  };
}
