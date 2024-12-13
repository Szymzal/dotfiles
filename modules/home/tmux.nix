{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.tmux;
in {
  options = {
    mypackages.tmux = {
      enable = mkEnableOption "Enable tmux";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      escapeTime = 50;
      terminal = "screen-256color";
      # TODO: Make it based on terminal choice
      shell = "${pkgs.zsh}/bin/zsh";
      extraConfig = "set-option -ga terminal-overrides \",screen-256color:Tc\"";
    };
  };
}
