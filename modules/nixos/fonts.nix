{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.fonts;
in {
  options = {
    mypackages.fonts = {
      enable = mkEnableOption "Enable fonts";
      # TODO: Add possibility to add custom fonts
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        # nerd-fonts.fira-code
        (nerdfonts.override {fonts = ["FiraCode"];}) # TODO: Update to format mensioned above after 25.05
        fira-code
      ];
    };
  };
}
