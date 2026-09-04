# based on:
# - https://github.com/Faeranne/nix-minecraft/blob/f4e4514f1d65b6a19704eab85070741e40c1d272/pkgs/forge-servers/derivation.nix
# - https://github.com/Infinidoge/nix-minecraft/blob/ab4790259bf8ed20f4417de5a0e5ee592094c7c3/pkgs/build-support/mkTextileLoader.nix
#
# Locks (lock_game.json, lock_launcher.json, lock_libraries.json)
# are copied from https://github.com/Faeranne/nix-minecraft/tree/f4e4514f1d65b6a19704eab85070741e40c1d272/pkgs/forge-servers
#
# Locks are modified to have only one version of Forge (1.20.1-47.3.1)
# I didn't want to deal with many versions of Forge

{
  lib,
  stdenvNoCC,
  fetchurl,
  gameVersion,
  loaderVersion,
  jre_headless,
  jq,
  vanillaServers,
}: let
  escapeVersion = lib.replaceStrings ["." " "] ["_" "_"];

  minecraftInfo = (lib.importJSON ./lock_versions.json)."${gameVersion}"."${loaderVersion}";

  forge-installer = "forge-${gameVersion}-${loaderVersion}-installer";

  mappingsInfo = minecraftInfo.mappings;
  mappings = fetchurl {
    name = "minecraft-mappings";
    version = "${gameVersion}";
    inherit (mappingsInfo) sha1 url;
  };

  vanilla = vanillaServers."vanilla-${escapeVersion gameVersion}";

  inherit (minecraftInfo) libraries;
  libraries_lock = lib.importJSON ./lock_libraries.json;

fetchedLibraries =
  libraries
  |> map (l: libraries_lock.${l})
  |> map (l: {
    lib = fetchurl {
      inherit (l) url sha1;
    };
    inherit (l) path;
  })
  |> lib.concatMapStrings (l: ''
    mkdir -p $(dirname $LIB/${l.path})
    ln -s ${l.lib} $LIB/${l.path}
  '');
in
  stdenvNoCC.mkDerivation {
    pname = "forge-loader";
    version = "${gameVersion}-${loaderVersion}";

    libraries = fetchedLibraries;

    src = fetchurl {
      name = forge-installer;
      inherit (minecraftInfo) url hash;
    };

    preferLocalBuild = true;

    installPhase =
      if (minecraftInfo.type == "installer")
      then
        (
          ''
            mkdir $out
            OUTPUT=$out/lib/minecraft/forge/${loaderVersion}
            LIB=$OUTPUT/libraries

            ${fetchedLibraries}

            MOJMAP_DIR_NAME=$(basename $LIB/de/oceanlabs/mcp/mcp_config/${gameVersion}-*)
            echo $MOJMAP_DIR_NAME
            MOJMAP_DIR=$LIB/net/minecraft/server/$MOJMAP_DIR_NAME
            mkdir -p "$MOJMAP_DIR"

            ln -s ${mappings} $MOJMAP_DIR/server-$MOJMAP_DIR_NAME-mappings.txt

            MINECRAFT_LIB=$LIB/net/minecraft/server/${gameVersion}
            mkdir -p "$MINECRAFT_LIB"

            ln -s ${vanilla}/lib/minecraft/server.jar $MINECRAFT_LIB/server-${gameVersion}.jar

            cp $src $OUTPUT/forge-installer.jar

            echo Patching forge installer...
            pushd $OUTPUT

            ${lib.getExe' jre_headless "jar"} xf $OUTPUT/forge-installer.jar install_profile.json

            mv $OUTPUT/install_profile.json $OUTPUT/install_profile_original.json

            ${lib.getExe jq} 'del(.processors[] | select(.args[1]=="DOWNLOAD_MOJMAPS"))' $OUTPUT/install_profile_original.json > $OUTPUT/install_profile.json
            mkdir -p $OUTPUT/META-INF
            touch $OUTPUT/META-INF/FORGE.RSA

            ${lib.getExe' jre_headless "jar"} uf $OUTPUT/forge-installer.jar install_profile.json META-INF/FORGE.RSA

            popd

            rm $OUTPUT/install_profile.json
            rm $OUTPUT/install_profile_original.json
            rm -rf $OUTPUT/META-INF

            echo Running installer...
            ${lib.getExe' jre_headless "java"} -jar $OUTPUT/forge-installer.jar --offline --installServer $OUTPUT

            echo Cleaning up...

            rm $OUTPUT/run.bat
            rm $OUTPUT/run.sh
            rm $OUTPUT/user_jvm_args.txt
            rm $OUTPUT/forge-installer.jar

            substituteInPlace $LIB/net/minecraftforge/forge/${gameVersion}-${loaderVersion}/unix_args.txt \
              --replace-warn libraries $LIB
          ''
        )
      # TODO: Make other types of Forge
      else throw "Cannot work with other types of packaging than installer!";

    dontUnpack = true;

    meta = with lib; {
      description = "Minecraft Server";
      homepage = "https://minecraft.net";
      license = licenses.unfreeRedistributable;
      platforms = platforms.unix;
      maintainers = with maintainers; [infinidoge];
      mainProgram = "minecraft-server";
    };
  }
