# copied from: https://github.com/fufexan/dotfiles/blob/78ce01ba573e6eab975498899dc72b3ea1e8523e/pkgs/bibata-hyprcursor/default.nix
{
  stdenvNoCC,
  bibata-cursors,
  hyprcursor,
  util-linux,
  xcur2png,
  jq,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bibata-hyprcursor";

  inherit (bibata-cursors) src version;

  nativeBuildInputs = [
    hyprcursor
    util-linux
    xcur2png
    jq
  ];

  buildPhase = ''
    runHook preBuild

    cp -r ${bibata-cursors}/share/icons ./original
    mkdir -p extracted themes icons svgs

    function fix_svgs {
      LENGTH=$(jq --arg theme "$theme" '.[$theme].colors | length' render.json)
      for (( i=0; i<$LENGTH; i++ )); do
        MATCH=$(jq --arg theme "$theme" --arg i "$i" '.[$theme].colors[$i|tonumber].match' render.json)
        MATCH="''${MATCH//\"}"
        REPLACE=$(jq --arg theme "$theme" --arg i "$i" '.[$theme].colors[$i|tonumber].replace' render.json)
        REPLACE="''${REPLACE//\"}"

        sed -i "s/$MATCH/$REPLACE/g" $file_path
        echo "Fixed svg: $file_path"
      done
    }

    for theme in ./original/*; do
      theme="$(basename $theme)"
      old_theme=$theme

      mkdir -p "svgs/$theme"

      FILES="./$(jq --arg theme "$theme" '.[$theme].dir' render.json)/*"
      FILES="''${FILES//\"}"
      for file in $FILES; do
        file_name="$(basename $file)"
        file_path="svgs/$theme/$file_name"
        cp -rL $file $file_path

        if [ -d $file_path ]; then
          old_file_path=$file_path
          for dir_file in $old_file_path/*; do
            new_file_name="$(basename $dir_file)"
            file_path=$old_file_path/$new_file_name
            fix_svgs
          done
        else
          fix_svgs
        fi
      done

      cp -r "./original/$theme" "./icons/$theme-hyprcursor"

      theme="$theme-hyprcursor"

      hyprcursor-util --extract "icons/$theme" --output extracted

      rename extracted_ "" extracted/*

      for file in ./extracted/$theme/hyprcursors/*; do
        file_name="$(basename $file).svg"
        path="svgs/$old_theme/$file_name"

        if [ -e $path ]; then
          cp $path $file
          rm -r $file/*.png

          LINE="define_size = 0, $file_name"
          sed -i 's/define_size =.*//g' $file/meta.hl
          sed -i '/^$/d' $file/meta.hl

          echo $LINE >> $file/meta.hl
        else
          file_name="$(basename $file)"
          path="svgs/$old_theme/$file_name"
          rm -r $file/*.png

          sed -i 's/define_size =.*//g' $file/meta.hl
          sed -i '/^$/d' $file/meta.hl

          for dir_file in $path/*; do
            file_name="$(basename $dir_file)"

            cp $dir_file $file

            LINE="define_size = 0, $file_name, 13"
            echo $LINE >> $file/meta.hl
          done
        fi
      done

      echo -e "name = $theme\ndescription = $theme for Hyprcursor\nversion = ${finalAttrs.version}\ncursors_directory = hyprcursors" >"extracted/$theme/manifest.hl"

      hyprcursor-util --create "extracted/$theme" --output themes
    done

    rename theme_ "" themes/*

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -dm 0755 $out/share/icons
    cp -rf themes/* $out/share/icons/

    runHook postInstall
  '';
})
