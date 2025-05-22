{
  lib,
  vimUtils,
  fetchFromGitHub,
  vimPlugins,
  nvim-session-manager,
  use_telescope ? true,
}:
vimUtils.buildVimPlugin {
  pname = "neovim-project";
  version = "2025-05-22";
  src = fetchFromGitHub {
    owner = "coffebar";
    repo = "neovim-project";
    rev = "1205c8221b133c4291c1076ffeb3db244393f058";
    hash = "sha256-ur5WAt+A8m3iDmMtUPfoGms0fqHGk+hgCRnXE+hjVKI=";
  };

  dependencies = with vimPlugins;
    [
      plenary-nvim
      nvim-session-manager
    ]
    ++ lib.optionals use_telescope [vimPlugins.telescope-nvim]
    ++ lib.optionals (!use_telescope) [vimPlugins.fzf-lua];
}
