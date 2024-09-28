{ pkgs }: {
  playit-agent = (pkgs.callPackage ./playit.nix { });
  forgeServers = (pkgs.callPackage ./forge-servers/default.nix { });
  bibata-hyprcursor = (pkgs.callPackage ./BibataCursor.nix { });
  casparcg-media-scanner = (pkgs.callPackage ./CasparCG/casparcg-media-scanner.nix { });
  casparcg-client = (pkgs.callPackage ./CasparCG/casparcg-client.nix { });
  casparcg-server = (pkgs.callPackage ./CasparCG/casparcg-server.nix { });
  vimPlugins = pkgs.vimPlugins // (pkgs.callPackage ./vimPlugins.nix { });
  myNodePackages = pkgs.callPackage ./nodePackages/node-packages.nix {
    nodeEnv = pkgs.callPackage ./nodePackages/node-env.nix {
      libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
    };
  };
  fetchModrinthModpack = (pkgs.callPackage ./fetchModrinthModpack.nix { });
}
