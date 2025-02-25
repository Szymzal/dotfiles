{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.mypackages.coding;
in {
  options = {
    mypackages.coding = {
      enable = mkEnableOption "Enable text editor for coding";
    };
  };

  config = mkIf cfg.enable (let
    package =
      (
        inputs.nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [../../shared/nvf];
        }
      )
      .neovim;
  in {
    stylix.targets.vim.enable = mkIf config.mypackages.theme.enable false;
    stylix.targets.neovim.enable = mkIf config.mypackages.theme.enable false;

    home.packages = [
      package
    ];

    xdg = {
      mime = {
        enable = mkDefault true;
      };
      mimeApps = let
        desktopFile = "nvim.desktop";
      in {
        enable = mkDefault true;
        associations.added = {
          "application/xml" = [desktopFile];
          "text/plain" = [desktopFile];
        };
        defaultApplications = {
          "application/xml" = [desktopFile];
          "text/plain" = [desktopFile];
        };
      };
    };
  });
}
