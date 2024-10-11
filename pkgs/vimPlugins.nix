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
}
