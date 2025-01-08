{
  lib,
  python3,
  fetchFromGitHub,
  qt5,
  wrapGAppsHook3,
  gobject-introspection,
  libjack2,
  ola,
  nix-update-script,
}: let
  version = "0.6.4";
in
  python3.pkgs.buildPythonApplication {
    pname = "linux-show-player";
    inherit version;
    pyproject = true;

    # 3.13 is unsupported for now
    disabled = with python3.pkgs; pythonOlder "3.8" || pythonAtLeast "3.13";

    src = fetchFromGitHub {
      owner = "FrancescoCeruti";
      repo = "linux-show-player";
      tag = "v${version}";
      hash = "sha256-QgsgG+SeHT9bZgSkpo5AKpm/YIifn7qRfe/C3paMS5o=";
    };

    nativeBuildInputs = [
      qt5.wrapQtAppsHook
      wrapGAppsHook3

      gobject-introspection
    ];

    build-system = with python3.pkgs; [poetry-core];

    dependencies = with python3.pkgs; [
      appdirs
      (falcon.overrideAttrs (attrs: {
        version = "3.1.3";
        src = fetchFromGitHub {
          owner = "falconry";
          repo = "falcon";
          rev = "refs/tags/${version}";
          hash = "sha256-7719gOM8WQVjODwOSo7HpH3HMFFeCGQQYBKktBAevig=";
        };
      }))
      jack-client
      mido
      pygobject3
      pyqt5
      python-rtmidi
      requests
      sortedcontainers
      humanize
      pyalsa

      (pyliblo.overrideAttrs (attrs: {
        patches =
          attrs.patches
          ++ [
            (pkgs.fetchurl {
              url = "https://github.com/dsacre/pyliblo/commit/ebbb255d6a73384ec2560047eab236660d4589db.patch?full_index=1";
              hash = "sha256-ZBAmBxSUT2xgoDVqSjq8TxW2jz3xR/pdCf2O3wMKvls=";
            })
          ];
      }))

      # Undocumented dependencies. *sigh*
      gst-python
      (ola.overrideAttrs (attrs: {
        patches = [
          (pkgs.fetchurl {
            url = "https://github.com/OpenLightingProject/ola/commit/d9b9c78645c578adb7c07b692842e841c48310be.patch?full_index=1";
            hash = "sha256-0t5HAXc/A8BNgHeeyywVICuQ6Tp3qs2YV7B1jTn/lPU=";
          })
        ];
      })) # Using Python bindings
    ];

    buildInputs = [libjack2];

    pythonRemoveDeps = [
      "pyqt5-qt5"
      "pyliblo3"
    ];

    dontWrapQtApps = true;
    dontWrapGApps = true;

    makeWrapperArgs = [
      ''--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [libjack2]}"''
      "\${qtWrapperArgs[@]}"
      "\${gappsWrapperArgs[@]}"
    ];

    passthru.updateScript = nix-update-script {};

    meta = {
      description = "Cue player designed for stage productions";
      changelog = "https://github.com/FrancescoCeruti/linux-show-player/releases/tag/v${version}";
      homepage = "https://linux-show-player.org/";
      license = with lib.licenses; [gpl3Only];
      maintainers = with lib.maintainers; [pluiedev];
      platforms = lib.platforms.linux;
      mainProgram = "linux-show-player";
    };
  }
