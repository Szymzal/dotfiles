{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.zoom;
in {
  options = {
    mypackages.zoom = {
      enable = mkEnableOption "Enable Zoom";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (zoom-us.overrideAttrs (attrs: {
        nativeBuildInputs = (attrs.nativeBuildInputs or []) ++ [pkgs.makeWrapper];
        postFixup =
          (attrs.postFixup or "")
          + ''
            wrapProgram $out/opt/zoom/zoom \
              --unset XDG_SESSION_TYPE
          '';
      }))
    ];

    mypackages.impermanence.files = [
      ".config/zoom.conf"
      ".config/zoomus.conf"
    ];
  };
}
