{
  lib,
  stdenv,
  fetchFromGitHub,
  juce,
  pkg-config,
  alsa-lib,
  freetype,
  curl,
  webkitgtk_4_0,
  gtk3-x11,
  libGL,
  bluez,
  jack2,
  hidapi,
  libusb1,
  SDL2,
  avahi,
  cmake,
  ninja,
  makeWrapper,
}:
stdenv.mkDerivation (let
  version = "1.9.25b10";

  juce-patched = juce.overrideAttrs (_: {
    src = fetchFromGitHub {
      owner = "benkuper";
      repo = "JUCE";
      rev = "ae44fa0d90c7970b009322a4a53ef767d09c8166";
      hash = "sha256-Dk66pXlJ/B9ezsDVqV0cxSNkqPVb2fqo4YGoCrCCHOE=";
    };
  });

  servus = stdenv.mkDerivation {
    pname = "servus";
    version = "1.5.2";

    src = fetchFromGitHub {
      owner = "HBPVIS";
      repo = "Servus";
      rev = "1f3514eaa1ab511b2db60a491438b29f6b558adb";
      hash = "sha256-2P5VW7IWvs7YPP7ryqQ+GrXnBy+6ZQwKNDNAR0E6dMA=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      cmake
      ninja
    ];

    buildInputs = [
      avahi
    ];
  };
in {
  pname = "Chataigne";
  inherit version;

  src = fetchFromGitHub {
    owner = "benkuper";
    repo = "Chataigne";
    rev = "${version}";
    hash = "sha256-nFTQRzjYS8vtIuuf9HJjI1bcPcOuFKgTAH1NCtTMlm8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    juce-patched
    alsa-lib
    freetype
    curl
    webkitgtk_4_0
    gtk3-x11
    libGL
    bluez
    jack2
    hidapi
    libusb1
    makeWrapper
  ];

  preBuild = ''
    cd Builds/LinuxMakefile
  '';

  makeFlags = [
    "CONFIG=Release"
    "CXXFLAGS=-I${juce-patched}/share/juce/modules"
    "LDFLAGS=-Wl,-rpath=${avahi}/lib"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp build/Chataigne $out/bin

    mkdir -p $out/share/applications
    cp $src/Builds/LinuxMakefile/Chataigne.AppDir/chataigne.desktop $out/share/applications

    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp $src/Builds/LinuxMakefile/Chataigne.AppDir/usr/share/icons/hicolor/256x256/apps/chataigne.png $out/share/icons/hicolor/256x256/apps
  '';

  postFixup = ''
    wrapProgram $out/bin/Chataigne \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [
      servus
      SDL2
    ]}
  '';

  meta = {
    mainProgram = "Chataigne";
  };
})
