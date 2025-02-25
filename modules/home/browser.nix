{
  lib,
  config,
  inputs,
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

  config = mkIf cfg.enable (let
    package = inputs.zen-browser.packages."x86_64-linux".default;
  in {
    home.packages = [
      package
    ];

    # programs.firefox = {
    #   enable = true;
    #   inherit package;
    #   policies = {
    #     Preferences = {
    #       "widget.use-xdg-desktop-portal.file-picker" = 1;
    #     };
    #   };
    # };

    xdg = {
      mime = {
        enable = mkDefault true;
      };
      mimeApps = let
        desktopFile = "zen.desktop";
      in {
        enable = mkDefault true;
        associations.added = {
          "x-scheme-handler/http" = [desktopFile];
          "x-scheme-handler/https" = [desktopFile];
          "x-scheme-handler/chrome" = [desktopFile];
          "text/html" = [desktopFile];
          "application/pdf" = [desktopFile];
          "application/x-extension-htm" = [desktopFile];
          "application/x-extension-html" = [desktopFile];
          "application/x-extension-shtml" = [desktopFile];
          "application/xhtml+xml" = [desktopFile];
          "application/x-extension-xhtml" = [desktopFile];
          "application/x-extension-xht" = [desktopFile];
        };
        defaultApplications = {
          "x-scheme-handler/http" = [desktopFile];
          "x-scheme-handler/https" = [desktopFile];
          "x-scheme-handler/chrome" = [desktopFile];
          "text/html" = [desktopFile];
          "application/x-extension-htm" = [desktopFile];
          "application/x-extension-html" = [desktopFile];
          "application/x-extension-shtml" = [desktopFile];
          "application/xhtml+xml" = [desktopFile];
          "application/x-extension-xhtml" = [desktopFile];
          "application/x-extension-xht" = [desktopFile];
        };
      };
    };

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
  });
}
