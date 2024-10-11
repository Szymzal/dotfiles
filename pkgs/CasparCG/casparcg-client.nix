{ stdenv
, fetchFromGitHub
, cmake
, git
, gnumake
, boost175
, qt6
, vlc
}:

stdenv.mkDerivation (let
  version = "2.3.0";
in {
  pname = "CasparCG-client";
  version = version;
  src = fetchFromGitHub {
    owner = "CasparCG";
    repo = "client";
    rev = "refs/tags/v${version}";
    hash = "sha256-Hf+L3PZl7W9kEUZ4a9HDTpwoD4i8oLrxFfMhc2f5nqs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    git
    gnumake
    boost175
    vlc
  ] ++ (with qt6; [
    qtbase
    qtwebsockets
    qt5compat
  ]);

  cmakeDir = "../src";

  postInstall = ''
    substituteInPlace $out/share/applications/casparcg-client.desktop --replace "/usr" "$out"
  '';
})
