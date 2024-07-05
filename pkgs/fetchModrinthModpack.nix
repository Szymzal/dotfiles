{ lib
, fetchurl
, stdenvNoCC
, unzip
, glibcLocalesUtf8
}:

{ pname ? ""
, version ? ""
, url
, hash
, removeProjectIDs ? []
, ...
}@args :
let
  # NOTE: fetchzip does fails with files with no read permission (modrinth.index.json)
  mrpack = (fetchurl {
    name = "source";
    inherit url hash;

    recursiveHash = true;
    downloadToTemp = true;
    nativeBuildInputs = [ unzip glibcLocalesUtf8 ];

    # copied from: https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/fetchzip/default.nix#L47
    postFetch = ''
      unpackDir="$TMPDIR/unpack"
      mkdir "$unpackDir"
      cd "$unpackDir"

      renamed="$TMPDIR/download.zip"
      mv "$downloadedFile" "$renamed"
      unpackFile "$renamed"
      chmod -R +rw "$unpackDir" # only this line has changed

      if [ $(ls -A "$unpackDir" | wc -l) != 1 ]; then
        echo "error: zip file must contain a single file or directory."
        echo "hint: Pass stripRoot=false; to fetchzip to assume flat list of files."
        exit 1
      fi
      fn=$(cd "$unpackDir" && ls -A)
      if [ -f "$unpackDir/$fn" ]; then
        mkdir $out
      fi
      mv "$unpackDir/$fn" "$out"

      chmod 755 "$out"
    '';
  });

  manifest = (lib.importJSON "${mrpack}/modrinth.index.json");
  pname' = if (pname == "") then manifest.name else pname;
  version' = if (version == "") then manifest.versionId else version;
  files = (lib.concatStringsSep " " (lib.flatten (lib.forEach manifest.files (file: (
  let
    drv = builtins.toString (fetchurl
      {
        inherit version;
        urls = file.downloads;
        sha512 = file.hashes.sha512;
      }
    );
    projectID = (builtins.elemAt (lib.splitString "/" (builtins.head file.downloads)) 4);
  in
  if (builtins.elem projectID removeProjectIDs) then [] else [ ''"${drv}"'' ''"${file.path}"'' ]
  )))));
in
stdenvNoCC.mkDerivation ({
  version = version';
  pname = pname';
  src = mrpack;

  dontFixup = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    FILES=(${files})
    for i in ''${!FILES[@]}
    do
      if [ $(($i % 2)) -eq 1 ]
      then
        continue
      fi

      mkdir -p "$out/$(dirname "''${FILES[$(($i + 1))]}")"
      find ''${FILES[$i]} -maxdepth 1 -type f -exec ln -s {} "$out/''${FILES[$(($i + 1))]}" \;

    done

    runHook postInstall
  '';

  passthru = {
    inherit manifest;
  };
} // args)
