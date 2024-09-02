{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.browser;
in
{
  options = {
    mypackages.browser = {
      enable = mkEnableOption "Enable browser";
    };
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        { id = "ghmbeldphafepmbegfdlkpapadhbakde"; } # Proton Pass
      ];
    };

    mypackages.impermanence = {
      directories = [
        ".config/chromium"
        "Downloads"
      ];
    };

    home.activation.symlinks = hm.dag.entryAfter ["writeBoundary"] ''
      run ln -sfn $HOME/Downloads $HOME/Pobrane
    '';
  };
}
