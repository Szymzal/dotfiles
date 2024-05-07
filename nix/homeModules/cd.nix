{ lib, config, osConfig, ... }:
with lib;
let
  cfg = config.mypackages.cd;
in
{
  options = {
    mypackages.cd = {
      enable = mkEnableOption "Enable cd replacement";
    };
  };

  config = mkIf cfg.enable {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = mkIf (osConfig.mypackages.shell.enable) true;
      enableBashIntegration = mkIf (!osConfig.mypackages.shell.enable) true;
    };

    programs.zsh.shellAliases = mkIf (osConfig.mypackages.shell.enable) {
      cd = "z";
    };

    programs.bash.shellAliases = mkIf (!osConfig.mypackages.shell.enable) {
      cd = "z";
    };
  };
}
