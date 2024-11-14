{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.localsend;
in {
  options = {
    mypackages.localsend = {
      enable = mkEnableOption "Enable LocalSend";
    };
  };

  config = mkIf cfg.enable {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
