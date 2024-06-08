# Copied from:
# - https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/misc/cups/drivers/brother/dcp375cw/default.nix
# - https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/misc/cups/drivers/brgenml1lpr/default.nix
{ stdenv
, lib
, fetchurl
, dpkg
, makeWrapper
, cups
, ghostscript
, a2ps
, gawk
, file
, gnused
, gnugrep
, coreutils
, which
}:
let
  model = "dcpj105";
  version = "3.0.0-1";
  patchElf = file: with lib; ''
    patchelf --set-interpreter \
      ${stdenv.cc.libc}/lib/ld-linux${optionalString stdenv.is64bit "-x86-64"}.so.2 \
      ${file}
  '';
in
stdenv.mkDerivation rec {
  inherit version;
  name = "${model}lpr-${version}-unwrapped";
  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103935/${model}lpr-${version}.i386.deb";
    sha256 = "1577lmp76pszh2hxrlqw9hh08z0gbl14s5vi9nnlyv1izgzmkr9x";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];
  buildInputs = [ cups ghostscript a2ps gawk stdenv.cc.libc ];

  unpackPhase = "dpkg-deb -x $src $out";

  dontBulid = true;

  patchPhase = ''
    LPDDIR=$out/opt/brother/Printers/${model}/lpd

    substituteInPlace $LPDDIR/filter${model} \
    --replace "/opt" "$out/opt"

    ${patchElf "$LPDDIR/br${model}filter"}
  '';

  installPhase = ''
    LPDDIR=$out/opt/brother/Printers/${model}/lpd
    CUPSFILTER_DIR=$out/lib/cups/filter

    mkdir -p $CUPSFILTER_DIR
    ln -s $LPDDIR/filter${model} $CUPSFILTER_DIR/brother_lpdwrapper_${model}

    wrapProgram $LPDDIR/filter${model} \
      --prefix PATH ":" ${
        lib.makeBinPath ([
          gawk
          ghostscript
          a2ps
          file
          gnused
          gnugrep
          coreutils
          which
        ])
      }
  '';

  dontPatchELF = true;
}
