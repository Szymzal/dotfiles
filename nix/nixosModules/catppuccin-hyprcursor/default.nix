{ pkgs, ... }: {
  environment.systemPackages = [
    # Until #18 is not merged (https://github.com/catppuccin/cursors/pull/18)
    (pkgs.stdenv.mkDerivation {
      name = "Catppuccin-Hyprcursor";
      src = pkgs.fetchFromGitHub {
        owner = "trowgundam";
        repo = "cursors";
        rev = "47be1f1e1f284b065d899af4245479e7ef2b410b";
        sha256 = "096v7dgxhwp9l2l92460agi51ka8ljpcp4iacw6n85cizaq3sjqk";
      };

      nativeBuildInputs = with pkgs; [
        coreutils
        git
      ];

      buildPhase = builtins.readFile ./build.sh;
      installPhase = ''
        runHook preInstall

        mkdir -p $out/share/icons
        mv dist/Catppuccin-* $out/share/icons

        runHook postInstall
      '';
    })
  ];
}
