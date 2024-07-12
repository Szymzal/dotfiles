{ stdenv
, fetchFromGitHub
, ffmpeg
}:
stdenv.mkDerivation (finalAttrs: {
  name = "media-scanner";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "CasparCG";
    repo = "media-scanner";
    rev = "v${finalAttrs.version}";
    hash = "sha256-qWMukQYfOynTsEg48wdMlM6a3HPvNR/LlsIRZhO8L0g=";
  };

  nativeBuildInputs = [
    ffmpeg
  ];
})
