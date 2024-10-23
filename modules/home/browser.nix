{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.browser;
in {
  options = {
    mypackages.browser = {
      enable = mkEnableOption "Enable browser";
    };
  };

  config = mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      extensions = [
        {id = "ghmbeldphafepmbegfdlkpapadhbakde";} # Proton Pass
      ];
      commandLineArgs = [
        "--enable-features=PulseaudioLoopbackForCast,PulseaudioLoopbackForScreenShare,WebRtcPipeWireCamera"
      ];
    };

    mypackages.impermanence = {
      directories = [
        ".config/chromium"
        ".local/share/applications" # PWAs
        "Downloads"
      ];
    };

    home.activation.symlinks = hm.dag.entryAfter ["writeBoundary"] ''
      run ln -sfn $HOME/Downloads $HOME/Pobrane
    '';
  };
}
