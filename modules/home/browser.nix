{ lib, config, pkgs, inputs, ... }:
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
    # programs.firefox = {
    #   enable = true;
    #   profiles.default = {
    #     settings = {
    #       "signon.rememberSignons" = false;
    #     };
    #     search = {
    #       engines = {
    #         "Nix Packages" = {
    #           urls = [{
    #             template = "https://search.nixos.org/packages";
    #             params = [
    #               { name = "type"; value = "packages"; }
    #               { name = "channel"; value = "unstable"; }
    #               { name = "query"; value = "{searchTerms}"; }
    #             ];
    #           }];
    #
    #           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    #           definedAliases = [ "@np" ];
    #         };
    #         "NixOS Options" = {
    #           urls = [{
    #             template = "https://search.nixos.org/options";
    #             params = [
    #               { name = "type"; value = "options"; }
    #               { name = "channel"; value = "unstable"; }
    #               { name = "query"; value = "{searchTerms}"; }
    #             ];
    #           }];
    #
    #           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    #           definedAliases = [ "@no" ];
    #         };
    #         "NixOS Home Manager Options" = {
    #           urls = [{
    #             template = "https://home-manager-options.extranix.com";
    #             params = [
    #               { name = "release"; value = "master"; }
    #               { name = "query"; value = "{searchTerms}"; }
    #             ];
    #           }];
    #
    #           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    #           definedAliases = [ "@nh" ];
    #         };
    #         "Noogle" = {
    #           urls = [{
    #             template = "https://noogle.dev/q";
    #             params = [
    #               { name = "term"; value = "{searchTerms}"; }
    #             ];
    #           }];
    #
    #           icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    #           definedAliases = [ "@ne" ];
    #         };
    #       };
    #       force = true;
    #     };
    #     # TODO: get somehow system architecture
    #     extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
    #       proton-pass
    #     ];
    #   };
    # };

    programs.chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };

    mypackages.impermanence = {
      directories = [
        # ".mozilla"
        "Downloads"
      ];
    };

    home.activation.symlinks = hm.dag.entryAfter ["writeBoundary"] ''
      run ln -sfn $HOME/Downloads $HOME/Pobrane
    '';
  };
}
