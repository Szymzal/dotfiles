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

  ts-comments-nvim = vimUtils.buildVimPlugin {
    name = "ts-comments.nvim";
    version = "2024-06-08";
    src = fetchFromGitHub {
      owner = "folke";
      repo = "ts-comments.nvim";
      rev = "e339090c076871069c00e488b11def49aaf4e413";
      sha256 = "1ZT5D3HnrJp4/zphTCkz8crT/cyERBBHYt2tcqYQMRE=";
    };
  };
}
