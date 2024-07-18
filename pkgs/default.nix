{ pkgs }: {
  bibata-hyprcursor = (pkgs.callPackage ./BibataCursor.nix { });
  casparcg-media-scanner = (pkgs.callPackage ./casparcg-media-scanner.nix { });
  casparcg-client = (pkgs.callPackage ./casparcg-client.nix { });
  casparcg-server = (pkgs.callPackage ./casparcg-server.nix { });
  vimPlugins = pkgs.vimPlugins // (pkgs.callPackage ./vimPlugins.nix { });
  myNodePackages = pkgs.callPackage ./nodePackages/node-packages.nix {
    nodeEnv = pkgs.callPackage ./nodePackages/node-env.nix {
      libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
    };
  };
  fetchModrinthModpack = (pkgs.callPackage ./fetchModrinthModpack.nix { });
}
