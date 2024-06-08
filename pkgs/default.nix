{ pkgs }:
let
  pkgs-i686 = pkgs.pkgsi686Linux;
in
{
  dcpj105lpr-unwrapped = pkgs-i686.callPackage ./dcpj105lpr-unwrapped.nix { };
  dcpj105lpr = pkgs-i686.callPackage ./dcpj105lpr.nix { };
  dcpj105cupswrapper = pkgs.callPackage ./dcpj105cupswrapper.nix { };
  myNodePackages = pkgs.callPackage ./nodePackages/node-packages.nix {
    nodeEnv = pkgs.callPackage ./nodePackages/node-env.nix {
      libtool = if pkgs.stdenv.isDarwin then pkgs.darwin.cctools else null;
    };
  };
}
