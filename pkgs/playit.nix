{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "playit-agent";
  version = "0.15.21";

  src = fetchFromGitHub {
    owner = "playit-cloud";
    repo = "playit-agent";
    rev = "v${version}";
    hash = "sha256-N+NCEI0UjYadMSUZNLfT7N3fTdMwgxxTNqImsCkSmhg=";
  };

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];

  cargoHash = "sha256-FXP6/7rK7IvXzWC7me2tySHbHnhaJ1Oqs0DJhq1ExJg=";

  # tests connect to a server
  doCheck = false;

  meta = {
    description = "Global proxy that allows anyone to host a server without port forwarding";
    homepage = "https://github.com/playit-cloud/playit-agent";
    changelog = "https://github.com/playit-cloud/playit-agent/releases/tag/${src.rev}";
    license = lib.licenses.bsd2;
    mainProgram = "playit-agent";
    platforms = lib.platforms.linux;
  };
}
