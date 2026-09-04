{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.mypackages.sops;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options = {
    mypackages.sops = {
      enable = mkEnableOption "Enable sops";
      defaultSopsFile = mkOption {
        default = null;
        example = literalExpression ''../../secrets/secrets.yaml'';
        description = "File with encrypted secrets";
        type = types.path;
      };
      defaultSopsFormat = mkOption {
        default = null;
        example = "yaml";
        description = "File format for encrypted secrets";
        type = types.str;
      };
      keyFile = mkOption {
        default = null;
        example = "/home/user/.config/sops/age/keys.txt";
        description = "File path to decryption";
        type = types.str;
      };
      secrets = mkOption {
        default = {};
        example = literalExpression ''
          {
            password = {
              neededForUsers = true;
            };
          }
        '';
        description = "Secrets described in secrets file";
        type = types.attrs;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sops
    ];

    sops.defaultSopsFile = cfg.defaultSopsFile;
    sops.defaultSopsFormat = cfg.defaultSopsFormat;

    sops.age.keyFile = cfg.keyFile;

    sops.secrets = cfg.secrets;
  };
}
