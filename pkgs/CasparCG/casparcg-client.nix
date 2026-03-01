{
  stdenv,
  fetchFromGitHub,
  cmake,
  git,
  gnumake,
  boost186, # FIX: Something is wrong with boost 1.87?
  qt6,
  vlc,
}:
stdenv.mkDerivation (let
  version = "2.3.1";
in {
  pname = "CasparCG-client";
  inherit version;
  src = fetchFromGitHub {
    owner = "CasparCG";
    repo = "client";
    rev = "refs/tags/v${version}";
    hash = "sha256-G1BiGq88z1gQfbQETyvsv6hlPfgk78vETI4CFPwyzJg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs =
    [
      git
      gnumake
      boost186
      vlc
    ]
    ++ (with qt6; [
      qtbase
      qtwebsockets
      qt5compat
    ]);

  cmakeDir = "../src";

  postInstall = ''
    substituteInPlace $out/share/applications/casparcg-client.desktop --replace "/usr" "$out"
  '';
})
