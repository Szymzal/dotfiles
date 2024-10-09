{ pkgs }: {
  opencv = pkgs.callPackage ({ enableCuda ? true, enablePython ? false, pythonPackages ? null, lib ? null, ... }@args:
    (pkgs.opencv.override args).overrideAttrs (_: {
      postInstall = ''
        sed -i "s|{exec_prefix}/$out|{exec_prefix}|;s|{prefix}/$out|{prefix}|" \
          "$out/lib/pkgconfig/opencv4.pc"
        mkdir "$cxxdev"
      '' + lib.optionalString (!enableCuda) ''
        mkdir -p "$cxxdev/nix-support"
        echo "''${!outputDev}" >> "$cxxdev/nix-support/propagated-build-inputs"
      '' + lib.optionalString (enableCuda) ''
        substituteInPlace "$out/lib/cmake/opencv4/OpenCVConfig.cmake" \
          --replace-fail \
            'find_host_package(CUDA ''${OpenCV_CUDA_VERSION} EXACT REQUIRED)' \
            'find_host_package(CUDA REQUIRED)' \
          --replace-fail \
            'message(FATAL_ERROR "OpenCV static library was compiled with CUDA' \
            'message("OpenCV static library was compiled with CUDA'
      '' + lib.optionalString (enablePython) ''
        pushd $NIX_BUILD_TOP/$sourceRoot/modules/python/package
        python -m pip wheel --verbose --no-index --no-deps --no-clean --no-build-isolation --wheel-dir dist .

        pushd dist
        python -m pip install ./*.whl --no-index --no-warn-script-location --prefix="$out" --no-cache

        # the cv2/__init__.py just tries to check provide "nice user feedback" if the installation is bad
        # however, this also causes infinite recursion when used by other packages
        rm -r $out/${pythonPackages.python.sitePackages}/cv2

        popd
        popd
      '';
    })
  ) { };
  playit-agent = (pkgs.callPackage ./playit.nix { });
  forgeServers = (pkgs.callPackage ./forge-servers/default.nix { });
  bibata-hyprcursor = (pkgs.callPackage ./BibataCursor.nix { });
  casparcg-media-scanner = (pkgs.callPackage ./CasparCG/casparcg-media-scanner.nix { });
  casparcg-client = (pkgs.callPackage ./CasparCG/casparcg-client.nix { });
  casparcg-server = (pkgs.callPackage ./CasparCG/casparcg-server.nix { });
  vimPlugins = pkgs.vimPlugins // (pkgs.callPackage ./vimPlugins.nix { });
  myNodePackages = pkgs.callPackage ./nodePackages/node-packages.nix {
    nodeEnv = pkgs.callPackage ./nodePackages/node-env.nix {
      libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
    };
  };
  fetchModrinthModpack = (pkgs.callPackage ./fetchModrinthModpack.nix { });
}
