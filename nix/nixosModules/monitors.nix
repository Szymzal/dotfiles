{ lib, config, ... }:
with lib;
let
  cfg = config.mypackages.monitors;
in
{
  options = {
    mypackages.monitors = mkOption {
      default = [];
      example = [];
      description = "Description of monitors you use";
      type = types.listOf (types.submodule {
        options = {
          enable = mkOption {
            default = true;
            example = false;
            description = "Enable/Disable monitor";
            type = types.bool;
          };
          primary = mkOption {
            default = false;
            example = true;
            description = "Make monitor primary";
            type = types.bool;
          };
          spec = {
            connector = mkOption {
              default = null;
              example = "DP-1";
              description = "Name of connector which monitor is connected";
              type = types.str;
            };
            vendor = mkOption {
              default = null;
              example = "AOC";
              description = "Name of vendor of monitor";
              type = types.str;
            };
            model = mkOption {
              default = null;
              example = "27G2G4";
              description = "Model of monitor";
              type = types.str;
            };
            serial = mkOption {
              default = null;
              example = "0x000008af";
              description = "Serial number of monitor";
              type = types.str;
            };
          };
          position = {
            x = mkOption {
              default = 0;
              example = 1920;
              description = "X position of logical monitor";
              type = types.int;
            };
            y = mkOption {
              default = 0;
              example = 1080;
              description = "Y position of logical monitor";
              type = types.int;
            };
          };
          mode = {
            width = mkOption {
              default = 0;
              example = 1920;
              description = "Width of screen in selected mode";
              type = types.ints.unsigned;
            };
            height = mkOption {
              default = 0;
              example = 1080;
              description = "Height of screen in selected mode";
              type = types.ints.unsigned;
            };
            rate = mkOption {
              default = 0;
              example = 144.00101;
              description = "Refresh rate of screen in selected mode";
              type = types.numbers.nonnegative;
            };
            scale = mkOption {
              default = 1;
              example = 2.0;
              description = "Scale of screen";
              type = types.numbers.positive;
            };
          };
        };
      });
    };
  };

  config = mkIf ((builtins.head cfg) != []) {
    assertions = [
      {
        assertion = ((builtins.head (builtins.filter (value: (value.enable && value.primary)) cfg)) != []);
        message = "No primary monitors!";
      }
      {
        assertion = ((builtins.length (builtins.filter (value: (value.enable && value.primary)) cfg)) < 2);
        message = "Multiple primary monitors!";
      }
    ];
  };
}
