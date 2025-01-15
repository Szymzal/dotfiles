{
  lib,
  rustPlatform,
  fetchFromGitHub,
  buildNpmPackage,
}:
rustPlatform.buildRustPackage (let
  src = fetchFromGitHub {
    owner = "ffplayout";
    repo = "ffplayout";
    rev = "v${version}";
    # hash = "sha256-u7flhAo+5i0cCoU2GGu9EfBhXnhGZWpchAYnMrt4IwI=";
    hash = "sha256-OZgyTRcfyoayX0mg9x1cEKXudfVXiTu/Hbygd82vaOM=";
  };

  version = "0.24.3";

  frontend = buildNpmPackage {
    pname = "ffplayout-frontend";
    inherit version;

    src = "${src}/frontend";

    NUXT_TELEMETRY_DISABLED = 1;

    # npmDepsHash = "sha256-DzpcaYItbxWCDX2haPMiOSuV7xpoYsZMiLB/w7YSJcI=";
    npmDepsHash = "sha256-DzpcaYItbxWCDX2haPMiOSuV7xpoYsZMiLB/w7YSJcI=";
  };
in rec {
  pname = "ffplayout";
  inherit version src;

  patches = [./remove_building_frontend.patch];

  nativeBuildInputs = [];
  buildInputs = [];

  # cargoHash = "sha256-pz1WS96o2k82gYDyMnggwOoBKlD4xv+DuVLKMCHKHk0=";
  cargoHash = "sha256-yVFkaX2x7q97p8qaLkum75q861/BMasQFiJ9XHkjN7I=";

  FRONTEND_DIR = "${frontend}/lib";

  meta = {
    description = "A 24/7 broadcasting solution. It can playout a folder containing audio or video clips, or play a JSON playlist for each day, keeping the current playlist editable.";
    homepage = "https://github.com/ffplayout/ffplayout";
    changelog = "https://github.com/ffplayout/ffplayout/releases/tag/${src.rev}";
    license = lib.licenses.gpl3;
    mainProgram = "ffplayout";
    platforms = lib.platforms.linux;
  };
})
