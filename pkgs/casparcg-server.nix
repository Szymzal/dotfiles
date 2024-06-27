{ stdenv
, fetchFromGitHub
, autoconf
, automake
, cmake
, ninja
, curl
, bzip2
, git
, gperf
, libtool
, gnumake
, perl
, pkg-config
, python3
, zlib
, expat
, lsb-release
, glew
, freeimage
, tbb
, openal
, xorg
, sfml
, systemd
, mesa_glu
, boost185
, nss
, ffmpeg
}:

stdenv.mkDerivation (let
  version = "2.4.0-stable";
in {
  pname = "CasparCG-server";
  version = version;
  src = fetchFromGitHub {
    owner = "CasparCG";
    repo = "server";
    rev = "refs/tags/v${version}";
    hash = "sha256-CnXDlaNB3peQ7BHGhH2/CIW8pdjmEqyhCyuj6LyBO8o=";
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
    zlib                # zlib1g-dev
    expat               # libexpat1-dev
    lsb-release
    glew                # libglew-dev
    freeimage           # libfreeimage-dev
    tbb                 # libtbb-dev
    openal              # libopenal-dev
    xorg.libXcursor     # libxcursor-dev
    xorg.libXinerama    # libxinerama-dev
    xorg.libXi          # libxi-dev
    sfml                # libsfml-dev
    xorg.libXrandr      # libxrandr-dev
    systemd             # libudev-dev
    mesa_glu            # libglu1-mesa-dev
    boost185            # libboost-all-dev
    nss                 # libnss3-dev
    ffmpeg
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_FFMPEG=ON"
  ];

  cmakeDir = "../src";

  preBuild = ''
    mkdir build
    cd build
  '';

  postBuild = ''
    make -j8
  '';
})
