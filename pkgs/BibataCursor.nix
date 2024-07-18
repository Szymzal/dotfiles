{ stdenvNoCC
, bibata-cursors
, hyprcursor
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bibata-hyprcursor";

  inherit (bibata-cursors) src version;

  nativeBuildInputs = [
    hyprcursor
  ];

  buildPhase = ''
    runHook preBuild

    cp -r ${bibata-cursors}/share/icons ./original
    mkdir -p extracted themes icons

    for theme in ./original/*; do
      theme="$(basename $theme)"

      cp -r "./original/$theme" "./icons/$theme-hyprcursor"

      theme="$theme-hyprcursor"

      hyprcursor-util --extract "icons/$theme" --output extracted

      rename extracted_ "" extracted/*

      echo -e "name = $theme\ndescription = $theme for Hyprcursor\nversion = ${finalAttrs.version}\ncursors_directory = hyprcursors" >"extracted/$theme/manifest.hl"

      hyprcursor-util --create "extracted/$theme" --output themes
    done

    rename theme_ "" themes/*

    runHook postBuild
  '';

  postBuild = ''
    ls -la
  '';
})
