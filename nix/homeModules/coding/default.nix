{ pkgs, ... }: {
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      git
      gcc
      lazygit
      ripgrep
      fd

      # LSPs
      rust-analyzer
      nil
      lua-language-server
      taplo
      vscode-langservers-extracted
      # nodePackages.@astrojs/language-server
      nodePackages.typescript-language-server
    ];
  };

  home.file = {
    ".config/nvim/lua".source = ./config/nvim/lua;
    ".config/nvim/init.lua".source = ./config/nvim/init.lua;
  };
}
