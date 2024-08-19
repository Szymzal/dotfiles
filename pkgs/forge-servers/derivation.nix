{ lib
, stdenvNoCC
, fetchurl
, gameVersion
, loaderVersion
, vanillaServers
, jre_headless
}:
let
  escapeVersion = lib.replaceStrings [ "." " " ] [ "_" "_" ];

  vanilla-server = vanillaServers."vanilla-${escapeVersion gameVersion}".override {
    jre_headless = jre_headless;
  };
  forge-installer = "forge-${gameVersion}-${loaderVersion}-installer";

  mappingsInfo = (lib.importJSON ./lock_game.json).${gameVersion}.mappings;
  mappings = fetchurl {
    name = "minecraft-mappings";
    inherit (mappingsInfo) sha1 url;
  };

  loader = (lib.importJSON ./lock_launcher.json).${gameVersion}.${loaderVersion};
  libraries = (lib.importJSON ./lock_game.json).${gameVersion}.libraries;
  libraries_lock = lib.importJSON ./lock_libraries.json;
  fetchedLibraries = lib.forEach libraries (l:
    let
      library = libraries_lock.${l};
    in
    fetchurl {
      inherit (library) url sha1;
    }
  );
in
stdenvNoCC.mkDerivation {
  pname = "minecraft-server-forge";
  version = "${gameVersion}-${loaderVersion}";

  libraries = fetchedLibraries;

  src = fetchurl {
    name = forge-installer;
    inherit (loader) url;
    hash = loader.md5;
  };

  preferLocalBuild = true;

  installPhase = if (loader.type == "installer") then (
  let
    libraries_path = lib.concatStringsSep " " (lib.forEach libraries (l: libraries_lock.${l}.path));
  in
  ''
    LIB_PATHS=(${libraries_path})

    mkdir $out

    for i in $libraries; do
      NIX_LIB=$(basename $i)
      NIX_LIB_NAME="''${NIX_LIB:33}"

      for l in ''${!LIB_PATHS[@]}; do
        LIB="''${LIB_PATHS[$l]}"
        LIB_NAME=$(basename $LIB)

        if [[ $LIB_NAME == $NIX_LIB_NAME ]]; then
          mkdir -p "$out/libraries/$(dirname $LIB)"
          ln -s $i $out/libraries/$LIB

          echo Linking library: $LIB_NAME

          break
        fi
      done
    done

    MOJMAP_DIR_NAME=$(basename "$out/libraries/de/oceanlabs/mcp/mcp_config/${gameVersion}-*")
    MOJMAP_DIR=$out/libraries/net/minecraft/server/$MOJMAP_DIR_NAME
    mkdir -p "$MOJMAP_DIR"

    ln -s ${mappings} $MOJMAP_DIR/server-$MOJMAP_DIR_NAME-mappings.txt

    MINECRAFT_LIB=$out/libraries/net/minecraft/server/${gameVersion}
    mkdir -p "$MINECRAFT_LIB"

    ln -s ${vanilla-server}/lib/minecraft/server.jar $MINECRAFT_LIB/server-${gameVersion}.jar

    ${jre_headless}/bin/java -jar $src --offline --installServer $out
  '') else throw "Cannot work with other types of packaging than installer!";

  dontUnpack = true;

  passthru = {
    updateScript = ./update.py;
  };

  meta = with lib; {
    description = "Minecraft Server";
    homepage = "https://minecraft.net";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinidoge ];
    mainProgram = "minecraft-server";
  };
}
