{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mypackages.cuda;
in {
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

    nixpkgs.config.cudaSupport = true;

    mypackages.cachix = {
      substituters = ["https://nix-community.cachix.org"];
      public-keys = ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="];
    };
  };
}
