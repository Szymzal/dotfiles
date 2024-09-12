# { stdenv
# , fetchzip
# , autoPatchelfHook
# , musl
# , ffmpeg
# }:
# stdenv.mkDerivation rec {
#   pname = "media-scanner";
#   version = "1.3.4";
#
#   src = fetchzip {
#     url = "https://github.com/CasparCG/media-scanner/releases/download/v${version}/casparcg-scanner-v${version}-linux-x64.zip";
#     stripRoot = false;
#     sha256 = "sha256-sxx7XDly0KPBOdn61FGXM+jZ6R4Iq5XUZRqKL24Jepk=";
#   };
#
#   nativeBuildInputs = [
#     ffmpeg
#     autoPatchelfHook
#   ];
#
#   buildInputs = [
#     musl
#   ];
#
#   dontBuild = true;
#
#   installPhase = ''
#     mkdir -p $out/bin
#     cp ./scanner $out/bin/caspar-scanner
#     cp -r ./prebuilds $out/bin/prebuilds
#   '';
# }

{ stdenvNoCC
, fetchFromGitHub
, nodejs_18
, yarn-berry
, cacert
, ffmpeg
, musl
, typescript
, pkg-config
}:

stdenvNoCC.mkDerivation (let 
  version = "1.3.4";
  src = fetchFromGitHub {
    owner = "CasparCG";
    repo = "media-scanner";
    rev = "v${version}";
    hash = "sha256-qWMukQYfOynTsEg48wdMlM6a3HPvNR/LlsIRZhO8L0g=";
  };
  patched-node = (nodejs_18.overrideAttrs (finalAttrs: previousAttrs: { version = "18.15.0"; sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; patches = [ ./node.v18.15.0.cpp.patch ]; }));
in rec {
  pname = "media-scanner";
  inherit version src;

  nativeBuildInputs = [ nodejs_18 yarn-berry ffmpeg pkg-config ];
  buildInputs = [ musl typescript ];

  patches = [
    ./patch.patch
  ];

  yarnOfflineCache = stdenvNoCC.mkDerivation {
    name = "media-scanner-deps";
    inherit src;

    nativeBuildInputs = [ yarn-berry ];

    supportedArchitectures = builtins.toJSON {
      os = [ "darwin" "linux" ];
      cpu = [ "arm" "x64" ];
      libc = [ "glibc" "musl" ];
    };

    patches = [
      ./patch.patch
    ];

    NODE_EXTRA_CA_CERTS = "${cacert}/etc/ssl/certs/ca-bundle.crt";

    configurePhase = ''
      runHook preConfigure

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

  # cp "${(nodejs_18.overrideAttrs (finalAttrs: previousAttrs: { patches = [ ./node.v18.15.0.cpp.patch ]; }))}/bin/node" ".pkg-cache/v3.4/build-v18.5.0-linux-x64"
  #
  # cp "${nodejs_18}/bin/node" ".pkg-cache/v3.4/built-v18.5.0-alpine-x64"
  # cp "${nodejs_18}/bin/node" ".pkg-cache/v3.4/built-v18.5.0-linux-x64"
  configurePhase = ''
    runHook preConfigure

    export HOME="$NIX_BUILD_TOP"
    export YARN_ENABLE_TELEMETRY=0
    export PKG_CACHE_PATH=".pkg-cache"

    mkdir -p ".pkg-cache/v3.4"

    cp "${patched-node}/bin/node" ".pkg-cache/v3.4/build-v18.5.0-linux-x64"
    cp "${patched-node}/bin/node" ".pkg-cache/v3.4/build-v18.5.0-alpine-x64"

    yarn config set enableGlobalCache false
    yarn config set cacheFolder $yarnOfflineCache

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn install --immutable --immutable-cache
    yarn build

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out
    cp -r dist/. $out/
  '';
})
