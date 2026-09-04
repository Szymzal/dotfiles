{
  vimUtils,
  fetchFromGitHub,
  vimPlugins,
  callPackage,
}: rec {
  neovim-project = callPackage ./neovim-project.nix {inherit nvim-session-manager;};

  nvim-session-manager = vimUtils.buildVimPlugin {
    pname = "neovim-session-manager";
    version = "2025-05-22";
    src = fetchFromGitHub {
      owner = "Shatur";
      repo = "neovim-session-manager";
      rev = "3409dc920d40bec4c901c0a122a80bee03d6d1e1";
      hash = "sha256-k2akj/s6qJx/sCnz3UNHo5zbENTpw+OPuo2WPF1W7rg=";
    };

    dependencies = with vimPlugins; [
      plenary-nvim
    ];
  };
}
