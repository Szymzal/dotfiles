{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.ghidra;
in {
  options = {
    mypackages.ghidra = {
      enable = mkEnableOption "Enable Ghidra";
    };
  };

  config = mkIf cfg.enable {
    programs.ghidra.enable = true;
  };
}
