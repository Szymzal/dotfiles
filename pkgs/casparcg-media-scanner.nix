{ stdenv
, fetchzip
, autoPatchelfHook
, musl
, ffmpeg
}:
stdenv.mkDerivation rec {
  pname = "media-scanner";
  version = "1.3.4";

  src = fetchzip {
    url = "https://github.com/CasparCG/media-scanner/releases/download/v${version}/casparcg-scanner-v${version}-linux-x64.zip";
    stripRoot = false;
    sha256 = "sha256-sxx7XDly0KPBOdn61FGXM+jZ6R4Iq5XUZRqKL24Jepk=";
  };

  nativeBuildInputs = [
    ffmpeg
    autoPatchelfHook
  ];

  buildInputs = [
    musl
  ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ./scanner $out/bin/caspar-scanner
    cp -r ./prebuilds $out/bin/prebuilds
  '';
}
