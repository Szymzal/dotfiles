{pkgs}: {
  playit-agent = pkgs.callPackage ./playit.nix {};
  forgeServers = pkgs.callPackage ./forge-servers/default.nix {};
  bibata-hyprcursor = pkgs.callPackage ./BibataCursor.nix {};
  casparcg-media-scanner = pkgs.callPackage ./CasparCG/casparcg-media-scanner.nix {};
  casparcg-client = pkgs.callPackage ./CasparCG/casparcg-client.nix {};
  casparcg-server = pkgs.callPackage ./CasparCG/casparcg-server.nix {};
  ontime = pkgs.callPackage ./ontime.nix {};
  fetchModrinthModpack = pkgs.callPackage ./fetchModrinthModpack.nix {};
}
