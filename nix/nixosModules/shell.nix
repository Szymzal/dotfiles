{ pkgs, lib, config, ... }: 
with lib;
let
  cfg = config.mypackages.shell;
in
{
  options = {
    mypackages.shell = {
      enable = mkEnableOption "Enable shell";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autosuggestions.enable = true;
      shellAliases = {};
      histSize = 10000;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" ];
        theme = "robbyrussell";
      };
      syntaxHighlighting.enable = true;
    };

    # Configure new shell
    environment.shells = with pkgs; [ zsh ];
  };
}
