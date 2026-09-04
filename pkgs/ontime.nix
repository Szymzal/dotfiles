{
  stdenv,
  lib,
  fetchFromGitHub,
  electron,
  makeBinaryWrapper,
  nodejs_20,
  pnpm_9,
  writeShellScriptBin,
}:
stdenv.mkDerivation (let
  version = "3.10.3";
  pnpm = pnpm_9.override {nodejs = nodejs_20;};

  server = writeShellScriptBin "ontime-server" ''
    cd OUT_DIR
    ${lib.getExe' nodejs_20 "node"} server/docker.cjs
  '';
in
  finalAttrs: {
    pname = "ontime";
    inherit version;
    src = fetchFromGitHub {
      owner = "cpvalente";
      repo = "ontime";
      rev = "refs/tags/v${version}";
      hash = "sha256-okbG8xpNzai2uw46kv3CBqSRCXYsVr4rsWrihn+wqoY=";
    };

    nativeBuildInputs = [
      nodejs_20
      pnpm.configHook
      makeBinaryWrapper
    ];

    env.ELECTRON_SKIP_BINARY_DOWNLOAD = true;

    buildPhase = ''
      runHook preBuild

      substituteInPlace apps/electron/package.json \
        --replace-fail "\"target\": \"AppImage\"" "\"target\": \"dir\"" \
        --replace-fail "\"artifactName\": \"ontime-linux.AppImage\"" "\"artifactName\": \"ontime-client-linux\""

      pnpm --filter "ontime-ui" postinstall
      pnpm --filter "ontime-server" postinstall
      pnpm build
      pnpm build:localdocker
      pnpm dist-linux -- -c.electronDist=${electron.dist} -c.electronVersion=${electron.version}

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/ontime
      cp -r apps/electron/dist/linux-unpacked/* $out/lib/ontime/

      mkdir -p $out/bin
      cp ${server}/bin/ontime-server $out/bin/ontime-server

      runHook postInstall
    '';

    postFixup = ''
      makeWrapper $out/lib/ontime/ontime-electron $out/bin/ontime \
        --add-flags "--no-sandbox --disable-gpu-sandbox" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

      substituteInPlace $out/bin/ontime-server \
        --replace-fail "OUT_DIR" "$out/lib/ontime/resources/extraResources"
    '';

    pnpmDeps = pnpm.fetchDeps {
      inherit (finalAttrs) pname version src;
      hash = "sha256-aMDb9L/zWcTHmE0PFuMLPevNRXeqyAXGswPHCg2pddw=";
    };
  })
