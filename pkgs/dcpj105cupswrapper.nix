# Copied from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/misc/cups/drivers/brother/dcp375cw/default.nix
{ stdenv
, lib
, fetchurl
, dpkg
, makeWrapper
, cups
, ghostscript
, a2ps
, gawk
, gnused
, gnugrep
, coreutils
}:
let
  model = "dcpj105";
  version = "3.0.0-1";
in
stdenv.mkDerivation {
  inherit version;
  name = "${model}cupswrapper-${version}";
  src = fetchurl {
    url = "https://download.brother.com/welcome/dlf103935/${model}cupswrapper-${version}.i386.deb";
    sha256 = "00gc4ak17h8jbakwsgrzvv85mrpcp6hm2q32cy7bbwnl5k6gsanb";
  };

  nativeBuildInputs = [ dpkg makeWrapper ];
  buildInputs = [ cups ghostscript a2ps gawk ];
  unpackPhase = "dpkg-deb -x $src $out";

  installPhase = ''
    for f in $out/opt/brother/Printers/${model}/cupswrapper/cupswrapper${model}; do
      wrapProgram $f --prefix PATH : ${
        lib.makeBinPath ([ coreutils ghostscript gnugrep gnused ])
      }
    done

    mkdir -p $out/share/cups/model
    ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/
  '';
}
