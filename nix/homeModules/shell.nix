{ lib, osConfig, ... }:
with lib;
{
  config = mkIf (osConfig.mypackages.shell.enable) {
    programs.zsh.enable = true;
  };
}
