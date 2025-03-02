{
  stdenv,
  dpkg,
  autoPatchelfHook,
  libGL,
  xorg,
  libsForQt5,
  alsa-lib,
  cups,
  dbus,
  libdrm,
  expat,
  fontconfig,
  freetype,
  mesa,
  lcms,
  lttng-ust_2_12,
  nss,
  libtiff,
  systemdLibs,
  wayland,
  libxkbcommon,
  libxmlb,
  libxslt,
  zlib,
  python39,
}:
stdenv.mkDerivation {
  name = "GstarCAD";
  src = ./gstarcad_25.0_amd64.deb;

  inherit dpkg;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  dontWrapQtApps = true;

  buildInputs =
    [
      dpkg
      stdenv.cc.cc.lib
      libGL
      alsa-lib
      cups
      dbus
      libdrm
      expat
      fontconfig
      freetype
      mesa
      lcms
      lttng-ust_2_12
      nss
      libtiff # TODO: Probably fix
      systemdLibs
      wayland
      libxkbcommon
      libxmlb
      libxslt
      zlib
      python39
    ]
    ++ (with libsForQt5.qt5; [
      qtbase
      qtwayland
    ])
    ++ (with xorg; [
      libICE
      libSM
      libX11
      libXcomposite
      libXdamage
      libXext
      libXfixes
      libXScrnSaver
      libXxf86vm
      libxcb
      libxshmfence
    ]);

  autoPatchelfIgnoreMissingDeps = [
    "GcModelerGeometry.gdx"
    "gcbr.gdx"
    "sdai.gdx"
    "gcdyn.gdx"
    "BimDb.gdx"
    "Ifc2Dwg.gdx"
    "InMemoryDatabase.gdx"
    "Iges2Dwg.gdx"
    "Step2Dwg.gdx"
    "StepBrepBuilder.gdx"
    "IgesBrepBuilder.gdx"
    "GcWinEmu.grx"
    "IAecDbObject.grx"
    "IMepDbObject.grx"
    "GcWinEmu.grx"
    "gcdgn.gdx"
    "IfcBrepBuilder.gdx"
    "GcDgnLS.gdx"
    "GcModelDocObj.gdx"
    "remotedebug.grx"
    "GcDbConstraints.gdx"
    "GcDgnLS.gdx"
    "GcGeolocationObj.gdx"
    "GcModelDocObj.gdx"
    "GcDbConstraints.gdx"
    "IWtDbObject.grx"
    "IHvacDbObject.grx"
    "IElecDbObject.grx"
    "IExtDbObject.grx"
  ];

  unpackPhase = ''
    dpkg-deb --fsys-tarfile $src | \
      tar -x --no-same-owner

    mkdir $out
    mv {usr,opt} $out
  '';

  preBuild = ''
    addAutoPatchelfSearchPath "$out/opt/apps/gstarsoft.gstarcad2025/files/"
  '';

  preFixup = ''
    patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/apps/gstarsoft.gstarcad2025/files/qtplugins/imageformats/libqtiff.so

    patchelf --replace-needed libpython3.6m.so.1.0 libpython3.9.so.1.0 $out/opt/apps/gstarsoft.gstarcad2025/files/{GcPyRuntime/Python3.6/pygcad/core/runtime.cpython-36m-x86_64-linux-gnu.so,libpyloader36.so}
    patchelf --replace-needed libpython3.7m.so.1.0 libpython3.9.so.1.0 $out/opt/apps/gstarsoft.gstarcad2025/files/{GcPyRuntime/Python3.7/pygcad/core/runtime.cpython-37m-x86_64-linux-gnu.so,libpyloader37.so}
    patchelf --replace-needed libpython3.5m.so.1.0 libpython3.9.so.1.0 $out/opt/apps/gstarsoft.gstarcad2025/files/libpyloader35.so
    patchelf --replace-needed libpython3.8.so.1.0 libpython3.9.so.1.0 $out/opt/apps/gstarsoft.gstarcad2025/files/libpyloader38.so
  '';
}
