{
  stdenv,
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
  sfml,
  systemd,
  mesa_glu,
  boost,
  nss,
  ffmpeg_6-full, # FIX: FFMPEG 7 does not work see: https://github.com/CasparCG/server/issues/1586
  icu,
}:
stdenv.mkDerivation (let
  version = "2.4.2";
  release = "stable";
in {
  pname = "CasparCG-server";
  version = version;
  src = fetchFromGitHub {
    owner = "CasparCG";
    repo = "server";
    rev = "refs/tags/v${version}-${release}";
    hash = "sha256-AnI7MmCwG2El/+K2RDYCaF690LnjNPlT5RahT7CKWNo=";
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
    (freeimage.overrideAttrs (attrs: {
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
    })) # libfreeimage-dev
    tbb # libtbb-dev
    openal # libopenal-dev
    xorg.libXcursor # libxcursor-dev
    xorg.libXinerama # libxinerama-dev
    xorg.libXi # libxi-dev
    sfml # libsfml-dev
    xorg.libXrandr # libxrandr-dev
    systemd # libudev-dev
    mesa_glu # libglu1-mesa-dev
    boost # libboost-all-dev
    nss # libnss3-dev
    ffmpeg_6-full
    icu
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_STATIC_BOOST=OFF"
    # TODO: Make it work
    "-DENABLE_HTML=OFF" # TODO: until I find a way to install caspar-cef-117: https://github.com/CasparCG/server/blob/master/src/CMakeModules/Bootstrap_Linux.cmake#L62
  ];

  patches = [
    # FIX: Wait to it to be deployed: https://github.com/CasparCG/server/pull/1584
    (fetchpatch2 {
      url = "https://patch-diff.githubusercontent.com/raw/CasparCG/server/pull/1584.patch";
      hash = "sha256-8XdluwjXrCjC7YkuKlMnm7d++fslcSthGR7iLTbw22Q=";
    })
  ];

  cmakeDir = "../src";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv staging/bin/casparcg $out/bin/casparcg-server

    runHook postInstall
  '';
})
