{ lib, config, osConfig, ... }:
with lib;
let
  cfg = config.mypackages.ls;
in
{
  options = {
    mypackages.ls = {
      enable = mkEnableOption "Enable ls replacement";
    };
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = mkIf (osConfig.mypackages.shell.enable) true;
      enableBashIntegration = mkIf (!osConfig.mypackages.shell.enable) true;
    };

    programs.zsh.shellAliases = mkIf (osConfig.mypackages.shell.enable) {
      ls = "eza";
    };

    programs.bash.shellAliases = mkIf (!osConfig.mypackages.shell.enable) {
      ls = "eza";
    };
  };
}
