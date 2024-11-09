{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.mypackages.blender;
in {
  options = {
    mypackages.blender = {
      enable = mkEnableOption "Enable Blender";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # TODO: remove when merged to unstable
      # https://nixpk.gs/pr-tracker.html?pr=354095
      (blender.override {
        openvdb = openvdb.overrideAttrs (attrs: rec {
          name = "${attrs.pname}-${version}";
          version = "11.0.0";
          src = fetchFromGitHub {
            owner = "AcademySoftwareFoundation";
            repo = "openvdb";
            rev = "v${version}";
            sha256 = "sha256-wDDjX0nKZ4/DIbEX33PoxR43dJDj2NF3fm+Egug62GQ=";
          };
          meta =
            attrs.meta
            // {
              license = lib.licenses.mpl20;
            };
        });
      })
    ];

    mypackages.impermanence.directories = [
      ".config/blender"
    ];
  };
}
