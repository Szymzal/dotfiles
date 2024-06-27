{ vimUtils, luajitPackages, fetchFromGitHub }:
{
  lua-utils-nvim = vimUtils.buildVimPlugin {
    inherit (luajitPackages.lua-utils-nvim) pname version src;
  };

  pathlib-nvim = vimUtils.buildVimPlugin {
    inherit (luajitPackages.pathlib-nvim) pname version src;
  };

  luarocks-nvim = vimUtils.buildVimPlugin {
    name = "luarocks.nvim";
    version = "2024-06-08";
    src = fetchFromGitHub {
      owner = "vhyrro";
      repo = "luarocks.nvim";
      rev = "1db9093915eb16ba2473cfb8d343ace5ee04130a";
      sha256 = "siqpyQLpxWYfZKxoPrflnCg8V5oTQcIXKrezjCgZfMM=";
    };
  };

  luvit-meta = vimUtils.buildVimPlugin {
    name = "luvit-meta";
    version = "2024-06-27";
    src = fetchFromGitHub {
      owner = "Bilal2453";
      repo = "luvit-meta";
      rev = "ce76f6f6cdc9201523a5875a4471dcfe0186eb60";
      sha256 = "1ZT5D3HnrJp4/zphTCkz8crT/cyERBBHYt2tcqYQMRE=";
    };
  };
}
