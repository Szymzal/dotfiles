{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.notes;
  isHomeManagerContext = builtins.hasAttr "home" config;
in
{
  options = {
    mypackages.notes = {
      enable = mkEnableOption "Enable note taking app";
    };
  };

  config = if (cfg.enable && isHomeManagerContext) then
      import ./home.nix
    else
      import ./nixos.nix;
}
