{pkgs}: {
  # TEMPORARY FIXES
  dmraid = pkgs.dmraid.overrideAttrs (attrs: {
    patches =
      attrs.patches
      ++ [
        ./fix-dmevent_tool.patch
      ];
  });

  python312Packages =
    pkgs.python312Packages
    // {
      patool = pkgs.python312Packages.patool.overrideAttrs (attrs: rec {
        version = "3.1.0";

        src = pkgs.fetchFromGitHub {
          owner = "wummel";
          repo = attrs.pname;
          rev = "refs/tags/${version}";
          hash = "sha256-mt/GUIRJHB2/Rritc+uNkolZzguYy2G/NKnSKNxKsLk=";
        };

        patches = [
          ./fix-rar-detection.patch
        ];

        disabledTests =
          attrs.disabledTests
          ++ [
            "test_7z"
            "test_7z_file"
            "test_7za_file"
            "test_p7azip"
          ];
      });
    };

  suitesparse = let
    stdenv = pkgs.overrideCC pkgs.stdenv pkgs.gcc13;
  in (pkgs.suitesparse.override {
    inherit stdenv;
  });

  playit-agent = pkgs.callPackage ./playit.nix {};
  forgeServers = pkgs.callPackage ./forge-servers/default.nix {};
  bibata-hyprcursor = pkgs.callPackage ./BibataCursor.nix {};
  casparcg-media-scanner = pkgs.callPackage ./CasparCG/casparcg-media-scanner.nix {};
  casparcg-client = pkgs.callPackage ./CasparCG/casparcg-client.nix {};
  casparcg-server = pkgs.callPackage ./CasparCG/casparcg-server.nix {};
  vimPlugins = pkgs.vimPlugins // (pkgs.callPackage ./vimPlugins.nix {});
  myNodePackages = pkgs.callPackage ./nodePackages/node-packages.nix {
    nodeEnv = pkgs.callPackage ./nodePackages/node-env.nix {
      libtool =
        if pkgs.stdenv.isDarwin
        then pkgs.darwin.cctools
        else null;
    };
  };
  fetchModrinthModpack = pkgs.callPackage ./fetchModrinthModpack.nix {};
}
