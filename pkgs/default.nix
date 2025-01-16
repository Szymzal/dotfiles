{pkgs}: {
  # TEMPORARY FIXES
  suitesparse = let
    stdenv = pkgs.overrideCC pkgs.stdenv pkgs.gcc13;
  in
    pkgs.suitesparse.override {
      inherit stdenv;
    };

  linux-show-player = pkgs.callPackage ./linux-show-player.nix {};
  python3 =
    pkgs.python3
    // {
      pkgs =
        {
          jack-client = pkgs.python3.pkgs.callPackage ./pythonModules/jack-client.nix {};
          pyalsa = pkgs.python3.pkgs.callPackage ./pythonModules/pyalsa.nix {};
        }
        // pkgs.python3.pkgs;
    };
  playit-agent = pkgs.callPackage ./playit.nix {};
  forgeServers = pkgs.callPackage ./forge-servers/default.nix {};
  bibata-hyprcursor = pkgs.callPackage ./BibataCursor.nix {};
  casparcg-media-scanner = pkgs.callPackage ./CasparCG/casparcg-media-scanner.nix {};
  casparcg-client = pkgs.callPackage ./CasparCG/casparcg-client.nix {};
  casparcg-server = pkgs.callPackage ./CasparCG/casparcg-server.nix {};
  ffplayout = pkgs.callPackage ./ffplayout.nix {};
  ontime = pkgs.callPackage ./ontime.nix {};
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
