{
  lib,
  config,
  inputs,
  pkgs,
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
    home.packages = with pkgs; [
      inputs.zen-browser.packages."x86_64-linux".default
      firefox
    ];

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
        ".zen"
        ".mozilla"
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
