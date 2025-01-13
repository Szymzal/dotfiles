{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.editor;
in {
  options = {
    mypackages.editor = {
      enable = mkEnableOption "Enable text editor";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [(
    inputs.nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [../shared/nvf];
  }).neovim];
  };
}
