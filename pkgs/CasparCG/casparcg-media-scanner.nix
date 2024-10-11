{ stdenvNoCC
, fetchFromGitHub
, nodejs_18
, yarn-berry
, cacert
, ffmpeg
, musl
, typescript
, writeShellScript
}:

stdenvNoCC.mkDerivation (let
  version = "1.3.4";
  src = fetchFromGitHub {
    owner = "CasparCG";
    repo = "media-scanner";
    rev = "v${version}";
    hash = "sha256-qWMukQYfOynTsEg48wdMlM6a3HPvNR/LlsIRZhO8L0g=";
  };
  runScript = writeShellScript "caspar-scanner" ''
    ${nodejs_18}/bin/node OUTDIR/lib/caspar-scanner/src $@
  '';
in rec {
  pname = "media-scanner";
  inherit version src;

  nativeBuildInputs = [ nodejs_18 yarn-berry ffmpeg ];
  buildInputs = [ musl typescript ];

  yarnOfflineCache = stdenvNoCC.mkDerivation {
    name = "media-scanner-deps";
    inherit src;

    nativeBuildInputs = [ yarn-berry ];

    supportedArchitectures = builtins.toJSON {
      os = [ "darwin" "linux" ];
      cpu = [ "arm" "x64" ];
      libc = [ "glibc" "musl" ];
    };

    NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    configurePhase = ''
      runHook preConfigure

      substituteInPlace yarn.lock --replace-fail "checksum: " "checksum: 10c0/"

      export HOME="$NIX_BUILD_TOP"
      export YARN_ENABLE_TELEMETRY=0

      yarn config set enableGlobalCache false
      yarn config set cacheFolder $out
      yarn config set supportedArchitectures --json "$supportedArchitectures"

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      mkdir -p $out
      yarn install --immutable --mode skip-build

      runHook postBuild
    '';

    dontInstall = true;

    outputHashAlgo = "sha256";
    outputHash = "sha256-9XL/fXlSMj6WtDSW6g58jCcwqBYwZwaT4IGVbzRFBX0=";
    outputHashMode = "recursive";
  };

  configurePhase = ''
    runHook preConfigure

    substituteInPlace yarn.lock --replace-fail "checksum: " "checksum: 10c0/"
    substituteInPlace src/config.ts --replace-warn ": 'ffmpeg'" ": '${ffmpeg}/bin/ffmpeg'"
    substituteInPlace src/config.ts --replace-warn ": 'ffprobe'" ": '${ffmpeg}/bin/ffprobe'"

    export HOME="$NIX_BUILD_TOP"
    export YARN_ENABLE_TELEMETRY=0

    yarn config set enableGlobalCache false
    yarn config set cacheFolder $yarnOfflineCache

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn install --immutable --immutable-cache
    yarn build:ts

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/lib/caspar-scanner/src
    mkdir -p $out/bin

    rm -rf dist/*{.ts,.map}
    cp -r dist/* $out/lib/caspar-scanner/src
    cp -r node_modules/ $out/lib/caspar-scanner
    cp package.json $out/lib/caspar-scanner
    cp ${runScript} $out/bin/caspar-scanner

    substituteInPlace $out/bin/caspar-scanner --replace-fail "OUTDIR" "$out"
  '';
})
