{
  vimUtils,
  fetchFromGitHub,
  vimPlugins,
}: {
  # FIX: Remove when upstream
  LazyVim = vimUtils.buildVimPlugin rec {
    pname = "LazyVim";
    version = "14.6.0";
    src = fetchFromGitHub {
      owner = "LazyVim";
      repo = "LazyVim";
      rev = "refs/tags/v${version}";
      hash = "sha256-yuVnGi2lFAF5T+HMWHBGH6ECWT25ebfha1jvx7uEHOk=";
    };

    dependencies = with vimPlugins; [lazy-nvim];
    nvimSkipModule = [
      "lazyvim.config.init"
      "lazyvim.config.keymaps"
      "lazyvim.plugins.extras.ai.tabnine"
      "lazyvim.plugins.extras.coding.luasnip"
      "lazyvim.plugins.extras.editor.fzf"
      "lazyvim.plugins.extras.editor.telescope"
      "lazyvim.plugins.extras.formatting.prettier"
      "lazyvim.plugins.extras.lang.markdown"
      "lazyvim.plugins.extras.lang.omnisharp"
      "lazyvim.plugins.extras.lang.python"
      "lazyvim.plugins.extras.lang.svelte"
      "lazyvim.plugins.extras.lang.typescript"
      "lazyvim.plugins.init"
      "lazyvim.plugins.ui"
      "lazyvim.plugins.xtras"
      "lazyvim.util.extras"
      "lazyvim.util.init"
      "lazyvim.util.plugin"
      "lazyvim.types"
    ];
  };

  # lua-utils-nvim = vimUtils.buildVimPlugin {
  #   inherit (luajitPackages.lua-utils-nvim) pname version src;
  # };
  #
  # pathlib-nvim = vimUtils.buildVimPlugin {
  #   inherit (luajitPackages.pathlib-nvim) pname version src;
  # };
  #
  # luarocks-nvim = vimUtils.buildVimPlugin {
  #   name = "luarocks.nvim";
  #   version = "2024-06-08";
  #   src = fetchFromGitHub {
  #     owner = "vhyrro";
  #     repo = "luarocks.nvim";
  #     rev = "1db9093915eb16ba2473cfb8d343ace5ee04130a";
  #     sha256 = "siqpyQLpxWYfZKxoPrflnCg8V5oTQcIXKrezjCgZfMM=";
  #   };
  # };
}
