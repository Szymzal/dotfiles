{
  stdenv,
  stdenvNoCC,
  lib,
  callPackage,
  fetchurl,
  fetchFromGitHub,
  fetchsvn,
  fetchpatch2,
  autoconf,
  automake,
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
  freeimage,
  tbb,
  openal,
  xorg,
  sfml_2,
  systemd,
  mesa_glu,
  boost186, # FIX: Something is wrong with boost 1.87?
  nss,
  ffmpeg-full,
  icu,
  enable_html ? true,
}:
stdenv.mkDerivation (let
  version = "2.4.3";
  release = "stable";

  freeimage-patched = freeimage.overrideAttrs (_: {
    src = fetchsvn {
      url = "svn://svn.code.sf.net/p/freeimage/svn/";
      rev = "1909";
      hash = "sha256-xgOFjonh/1oKUM6je8fMeswYp8Z9kwva5Cm05Wqu9AY=";
    };

    patches = [
      # Updated Original Patch
      ./unbundle.diff

      # Patches from Fedora
      # CVE-2020-29292
      (fetchpatch2 {
        url = "https://src.fedoraproject.org/rpms/freeimage/raw/rawhide/f/CVE-2020-24292.patch";
        hash = "sha256-U2TjHrV0PQrqnMic0+VWF3mBdZvu6CN+/+vpeNolGXU=";
      })
      # CVE-2020-29293
      (fetchpatch2 {
        url = "https://src.fedoraproject.org/rpms/freeimage/raw/rawhide/f/CVE-2020-24293.patch";
        hash = "sha256-kmY584C17Xi4+qqJAnN0M/3OB4K4Sa4M3jdJwvx32ig=";
      })
      # CVE-2020-29295
      (fetchpatch2 {
        url = "https://src.fedoraproject.org/rpms/freeimage/raw/rawhide/f/CVE-2020-24295.patch";
        hash = "sha256-B4Ls9lyizdgkEqyYDkIpqOBcWkekbYRhuadQJchtt30=";
      })
      ./CVE-2021-33367.patch # Modified https://src.fedoraproject.org/rpms/freeimage/raw/rawhide/f/CVE-2021-33367.patch
      ./CVE-2021-40263.patch # Modified https://src.fedoraproject.org/rpms/freeimage/raw/rawhide/f/CVE-2021-40263.patch
      ./CVE-2021-40266.patch # Modified https://src.fedoraproject.org/rpms/freeimage/raw/rawhide/f/CVE-2021-40266.patch
      # CVE-2023-47995
      (fetchpatch2 {
        url = "https://src.fedoraproject.org/rpms/freeimage/raw/rawhide/f/CVE-2023-47995.patch";
        hash = "sha256-aET+Is8Mr9E+NV0VOQg1auodyuAAyrU8uM7wLl4HHSc=";
      })
      ./CVE-2023-47997.patch # Modified https://src.fedoraproject.org/rpms/freeimage/raw/rawhide/f/CVE-2023-47997.patch
    ];
  });

  libcef-121 = callPackage (fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixpkgs/374e6bcc403e02a35e07b650463c01a52b13a7c8/pkgs/development/libraries/libcef/default.nix";
    hash = "sha256-dCQStQlDnaIClhSBDH+Nwqr3OeI0rrZRDmnhJXf34nE=";
  }) {};

  cef = stdenvNoCC.mkDerivation (let
    LIB = "${libcef-121}/lib";
    LIBEXEC = "${libcef-121}/libexec/cef";
    SHARE = "${libcef-121}/share/cef";
    OUT = "$out/lib/casparcg-cef";
  in {
    name = "casparcg-cef";
    phases = ["installPhase"];
    installPhase = ''
      mkdir -p ${OUT}

      ln -s ${SHARE}/* ${OUT}/
      ln -s ${LIBEXEC}/* ${OUT}/
      ln -s ${LIB}/* ${OUT}/
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
    hash = "sha256-w0jBb4xdYyzNR7pYo9fg07jJ78k8DhROGog+VlohG3Y=";
  };

  nativeBuildInputs = [
    cmake
    ninja
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
    freeimage-patched # libfreeimage-dev
    tbb # libtbb-dev
    openal # libopenal-dev
    xorg.libXcursor # libxcursor-dev
    xorg.libXinerama # libxinerama-dev
    xorg.libXi # libxi-dev
    sfml_2 # libsfml-dev
    xorg.libXrandr # libxrandr-dev
    systemd # libudev-dev
    mesa_glu # libglu1-mesa-dev
    boost186 # libboost-all-dev
    nss # libnss3-dev
    ffmpeg-full
    icu
  ];

  preBuild = lib.optionals enable_html ''
    BOOTSTRAP_PATH=/build/source/src/CMakeModules/Bootstrap_Linux.cmake
    CEF_LIB_REPLACE=$(cat $BOOTSTRAP_PATH | grep "set(CEF_LIB_PATH \"/" | cut -d "\"" -f2)
    CEF_INCLUDE_REPLACE=$(cat $BOOTSTRAP_PATH | grep "set(CEF_INCLUDE_PATH \"/" | cut -d "\"" -f2)

    substituteInPlace $BOOTSTRAP_PATH \
      --replace-fail $CEF_LIB_REPLACE ${cef_out} \
      --replace-fail $CEF_INCLUDE_REPLACE ${libcef-121}
  ''; # Fix to be able to use custom CEF binary

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

  patches = [
    # FIX: Wait to it to be deployed: https://github.com/CasparCG/server/pull/1584
    (fetchpatch2 {
      url = "https://patch-diff.githubusercontent.com/raw/CasparCG/server/pull/1584.patch";
      hash = "sha256-8XdluwjXrCjC7YkuKlMnm7d++fslcSthGR7iLTbw22Q=";
    })
    ./fix_ffmpeg7.1_build.patch # FIX: Temporary fix, we don't know what consequences it will have. See: https://github.com/CasparCG/server/issues/1586
  ];

  cmakeDir = "../src";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv staging/bin/casparcg $out/bin/casparcg-server

    runHook postInstall
  '';

  meta = {
    mainProgram = "casparcg-server";
  };
})
