{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.blender;
in
{
  options = {
    mypackages.blender = {
      enable = mkEnableOption "Enable Blender";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Temporary fix until this is merged: https://github.com/NixOS/nixpkgs/pull/340100
      ((blender.overrideAttrs (finalAttrs: previousAttrs: {
        cmakeFlags = previousAttrs.cmakeFlags ++ [
          "-DWITH_BUILDINFO=OFF"
          "-DWITH_CPU_CHECK=OFF"
          "-DWITH_CYCLES_OSL=OFF"
          "-DWITH_JACK=OFF"
          "-DWITH_LIBS_PRECOMPILED=OFF"
          "-DWITH_PULSEAUDIO=OFF"
          "-DWITH_STRICT_BUILD_OPTIONS=ON"
        ];

        nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [
          pkgs.wayland-scanner
        ];
      })).override { cudaSupport = true; })
    ];

    mypackages.impermanence.directories = [
      ".config/blender"
    ];
  };
}
