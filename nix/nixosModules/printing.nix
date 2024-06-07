{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.mypackages.printing;
in
{
  options = {
    mypackages.printing = {
      enable = mkEnableOption "Enable printing";
    };
  };

  config = mkIf (cfg.enable) (let
    # Copied from https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/misc/cups/drivers/brother/dcp375cw/default.nix
    model = "dcpj105";
    version = "3.0.0-1";

    driver = pkgs.stdenv.mkDerivation {
      inherit version;
      name = "${model}lpr-${version}";
      src = pkgs.fetchurl {
        url = "https://download.brother.com/welcome/dlf103935/${model}lpr-${version}.i386.deb";
        sha256 = "1577lmp76pszh2hxrlqw9hh08z0gbl14s5vi9nnlyv1izgzmkr9x";
      };

      nativeBuildInputs = with pkgs; [ dpkg makeWrapper ];
      buildInputs = with pkgs; [ cups ghostscript a2ps gawk ];
      unpackPhase = "dpkg-deb -x $src $out";

      installPhase = ''
        substituteInPlace $out/opt/brother/Printers/${model}/lpd/filter${model} \
        --replace /opt "$out/opt"

        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
        $out/opt/brother/Printers/${model}/lpd/br${model}filter

        mkdir -p $out/lib/cups/filter/
        ln -s $out/opt/brother/Printers/${model}/lpd/filter${model} $out/lib/cups/filter/brlpdwrapper${model}

        wrapProgram $out/opt/brother/Printers/${model}/lpd/filter${model} \
          --prefix PATH ":" ${
            lib.makeBinPath (with pkgs; [
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
    };

    cupswrapper = pkgs.stdenv.mkDerivation {
      inherit version;
      name = "${model}cupswrapper-${version}";
      src = pkgs.fetchurl {
        url = "https://download.brother.com/welcome/dlf103935/${model}cupswrapper-${version}.i386.deb";
        sha256 = "00gc4ak17h8jbakwsgrzvv85mrpcp6hm2q32cy7bbwnl5k6gsanb";
      };

      nativeBuildInputs = with pkgs; [ dpkg makeWrapper ];
      buildInputs = with pkgs; [ cups ghostscript a2ps gawk ];
      unpackPhase = "dpkg-deb -x $src $out";

      installPhase = ''
        for f in $out/opt/brother/Printers/${model}/cupswrapper/cupswrapper${model}; do
          wrapProgram $f --prefix PATH : ${
            lib.makeBinPath (with pkgs; [ coreutils ghostscript gnugrep gnused ])
          }
        done

        mkdir -p $out/share/cups/model
        ln -s $out/opt/brother/Printers/${model}/cupswrapper/brother_${model}_printer_en.ppd $out/share/cups/model/
      '';
    };
  in
  {
    services.printing = {
      enable = true;
      drivers = [ driver cupswrapper ];
    };

    mypackages.impermanence.directories = [
      "/etc/cups"
    ];
  });
}
