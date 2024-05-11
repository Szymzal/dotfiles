{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.browser;
in
{
  options = {
    mypackages.browser = {
      enable = mkEnableOption "Enable browser";
    };
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # profiles.default = {
      #   bookmarks = [
      #     {
      #       name = "Nixos Search";
      #       url = "https://search.nixos.org/packages";
      #     }
      #     {
      #       name = "Home Manager Search";
      #       url = "https://home-manager-options.extranix.com";
      #     }
      #   ];
      # };
    };

    mypackages.impermanence = {
      directories = [
        ".mozilla"
        "Downloads"
      ];
    };

    home.activation.symlinks = hm.dag.entryAfter ["writeBoundary"] ''
      run ln -sfn $HOME/Downloads $HOME/Pobrane
    '';
  };
}
