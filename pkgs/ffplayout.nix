{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildNpmPackage,
  ffmpeg,
  makeWrapper,
}:
rustPlatform.buildRustPackage (let
  src = fetchFromGitHub {
    owner = "ffplayout";
    repo = "ffplayout";
    rev = "v${version}";
    hash = "sha256-u7flhAo+5i0cCoU2GGu9EfBhXnhGZWpchAYnMrt4IwI=";
  };

  version = "0.24.4";

  frontend = buildNpmPackage {
    pname = "ffplayout-frontend";
    inherit version;

    src = "${src}/frontend";

    NUXT_TELEMETRY_DISABLED = 1;

    npmDepsHash = "sha256-DzpcaYItbxWCDX2haPMiOSuV7xpoYsZMiLB/w7YSJcI=";
  };
in rec {
  pname = "ffplayout";
  inherit version src;

  patches = [./remove_building_frontend.patch];

  nativeBuildInputs = [makeWrapper];

  # Tests need ffmpeg in PATH
  preBuild = ''
    export PATH=$PATH:${ffmpeg}/bin
  '';

  cargoHash = "sha256-pz1WS96o2k82gYDyMnggwOoBKlD4xv+DuVLKMCHKHk0=";

  FRONTEND_DIR = "${frontend}/lib";

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    cp assets/ffplayout.service $out/lib/systemd/system/

    substituteInPlace $out/lib/systemd/system/ffplayout.service \
      --replace-fail "/usr" "$out"

    wrapProgram $out/bin/ffplayout \
    --prefix PATH ${lib.makeBinPath [
      ffmpeg
    ]}
  '';

  meta = {
    description = "A 24/7 broadcasting solution. It can playout a folder containing audio or video clips, or play a JSON playlist for each day, keeping the current playlist editable.";
    homepage = "https://github.com/ffplayout/ffplayout";
    changelog = "https://github.com/ffplayout/ffplayout/releases/tag/${src.rev}";
    license = lib.licenses.gpl3;
    mainProgram = "ffplayout";
    platforms = lib.platforms.linux;
  };
})
