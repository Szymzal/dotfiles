{ pkgs }: {
  vimPlugins = pkgs.vimPlugins // (pkgs.callPackage ./vimPlugins.nix { });
  myNodePackages = pkgs.callPackage ./nodePackages/node-packages.nix {
    nodeEnv = pkgs.callPackage ./nodePackages/node-env.nix {
      libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
    };
  };
}
