# Copied from: https://github.com/vimjoyer/nixconf/blob/96c9e1f17e19751185df9ea7a98b4cc27436b4e9/modules/wrappedPrograms/wlr-which-key/default.nix
{
  inputs,
  self,
  lib,
  ...
}: let
  mkWhichKey = pkgs: menu:
    (self.wrapperModules.which-key.apply {
      inherit pkgs;
      settings = {
        inherit menu;

        # font = "JetBrainsMono Nerd Font 12";
        # background = self.theme.base00;
        # color = self.theme.base06;
        # border = self.theme.base0F;
        separator = " ➜ ";
        border_width = 2;
        corner_r = 15;
        padding = 15;
        rows_per_column = 5;
        column_padding = 25;

        anchor = "bottom-right";
        margin_right = 0;
        margin_bottom = 5;
        margin_left = 5;
        margin_top = 0;
      };
    }).wrapper;
in {
  flake.mkWhichKeyExe = pkgs: menu: lib.getExe (mkWhichKey pkgs menu);

  flake.wrapperModules.which-key = inputs.wrapper-modules.lib.wrapModule (
    {
      config,
      lib,
      ...
    }: let
      yamlFormat = config.pkgs.formats.yaml {};
    in {
      options = {
        settings = lib.mkOption {
          type = yamlFormat.type;
        };
      };

      config = {
        package = config.pkgs.wlr-which-key;

        addFlag = [
          (toString (yamlFormat.generate "config.yaml" config.settings))
        ];
      };
    }
  );
}
