{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "playit-agent";
  version = "0.15.26";

  src = fetchFromGitHub {
    owner = "playit-cloud";
    repo = "playit-agent";
    rev = "v${version}";
    hash = "sha256-zmiv007/am9KnxpauelNNrfdJuJSqmDspLKqP6pCjIs=";
  };

  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];

  cargoHash = "sha256-JRsmZ5D/awsIjExGTDkzYkun6oeIpL1FkZJKzZf/XF0=";

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
