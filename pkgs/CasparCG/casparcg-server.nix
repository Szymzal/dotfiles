{
  stdenv,
  lib,
  fetchFromGitHub,
  autoconf,
  automake,
  makeBinaryWrapper,
  ndi,
  cmake,
  ninja,
  curl,
  bzip2,
  git,
  gperf,
  libtool,
  gnumake,
  perl,
  pkg-config,
  python3,
  zlib,
  expat,
  lsb-release,
  glew,
  cef-binary,
  tbb,
  openal,
  xorg,
  sfml_2,
  systemd,
  mesa_glu,
  boost188,
  nss,
  ffmpeg_7-full,
  icu,
  simde,
  enable_html ? true,
}:
stdenv.mkDerivation (let
  version = "2.5.0";
  release = "stable";
  cefVersion = "142.0.17";

  # https://github.com/CasparCG/dependencies/releases/download/cef/cef_binary_142.0.17+g60aac24+chromium-142.0.7444.176_linux64_minimal.tar.bz2
  cef-bin = cef-binary.override {
    version = cefVersion;
    gitRevision = "60aac24";
    chromiumVersion = "142.0.7444.176";
    srcHashes = {
      aarch64-linux = "";
      x86_64-linux = "sha256-HYnhmy9EYQX5of5v3Ja87YYkm1iEJB3MQBO3yU2r9CQ=";
    };
  };

  cef = stdenv.mkDerivation (let
    OUT = "$out/lib/casparcg-cef";
  in {
    name = "casparcg-cef";
    src = cef-bin;

    nativeBuildInputs = [cmake ninja];

    ninjaFlags = ["libcef_dll_wrapper"];

    installPhase = ''
      mkdir -p ${OUT}

      cp /build/cef-binary-${cefVersion}/build/libcef_dll_wrapper/libcef_dll_wrapper.a ${OUT}

      ln -s ${cef-bin}/Release/* ${OUT}/
      ln -s ${cef-bin}/Resources/* ${OUT}/
    '';
  });

  cef_out = "${cef}/lib/casparcg-cef";
in {
  pname = "CasparCG-server";
  inherit version;
  src = fetchFromGitHub {
    owner = "CasparCG";
    repo = "server";
    rev = "refs/tags/v${version}-${release}";
    hash = "sha256-1Ch0S5Iwk0knxisI/IgMgklUpAZiiq0VdO98j3yZj+w=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    makeBinaryWrapper
  ];

  buildInputs = [
    autoconf
    automake
    curl
    bzip2
    git
    gperf
    libtool
    gnumake
    perl
    pkg-config
    python3
    zlib # zlib1g-dev
    expat # libexpat1-dev
    lsb-release
    glew # libglew-dev
    tbb # libtbb-dev
    openal # libopenal-dev
    xorg.libXcursor # libxcursor-dev
    xorg.libXinerama # libxinerama-dev
    xorg.libXi # libxi-dev
    sfml_2 # libsfml-dev
    xorg.libXrandr # libxrandr-dev
    systemd # libudev-dev
    mesa_glu # libglu1-mesa-dev
    boost188 # libboost-all-dev
    nss # libnss3-dev
    ffmpeg_7-full # FFMPEG 8.0 removed libpostproc
    icu
    simde
  ];

  # Fix to be able to use custom CEF binary
  preConfigure = lib.optionals enable_html ''
    BOOTSTRAP_PATH=/build/source/src/CMakeModules/Bootstrap_Linux.cmake
    CEF_LIB_REPLACE=$(cat $BOOTSTRAP_PATH | grep "/usr/lib/casparcg-cef-" | cut -d "\"" -f2)
    CEF_INCLUDE_REPLACE=$(cat $BOOTSTRAP_PATH | grep "/usr/include/casparcg-cef-" | cut -d "\"" -f2)

    substituteInPlace $BOOTSTRAP_PATH \
      --replace-fail $CEF_LIB_REPLACE ${cef_out} \
      --replace-fail $CEF_INCLUDE_REPLACE ${cef-bin}
  '';

  cmakeFlags =
    [
      "-DUSE_SYSTEM_FFMPEG=ON"
      "-DUSE_STATIC_BOOST=OFF"
      "-DUSE_SYSTEM_CEF=ON"
    ]
    ++ lib.optionals enable_html [
      "-DCEF_BIN_PATH=${cef_out}"
      "-DENABLE_HTML=ON"
    ]
    ++ lib.optionals (!enable_html) [
      "-DENABLE_HTML=OFF"
    ];

  cmakeDir = "../src";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv shell/casparcg $out/bin/casparcg-server

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/casparcg-server \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ndi]}
  '';

  meta = {
    mainProgram = "casparcg-server";
  };
})
