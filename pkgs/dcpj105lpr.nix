{ buildFHSEnv, dcpj105lpr-unwrapped }:
let
  model = "dcpj105";
  version = "3.0.0-1";
in
buildFHSEnv rec {
  inherit version;
  name = "${model}lpr-${version}";
  multiArch = true;
  multiPkgs = pkgs: [
    dcpj105lpr-unwrapped
  ];

  extraInstallCommands = ''
    BRDIR=opt/brother/Printers/${model}

    mkdir -p $out/$BRDIR
    cp -r ${dcpj105lpr-unwrapped}/$BRDIR/inf $out/$BRDIR/inf

    CUPSFILTER_DIR=$out/lib/cups/filter

    mkdir -p $CUPSFILTER_DIR
    ln -s $out/bin/${name} $CUPSFILTER_DIR/brother_lpdwrapper_${model}
  '';

  runScript = "${dcpj105lpr-unwrapped}/opt/brother/Printers/dcpj105/lpd/filter${model}";
}
