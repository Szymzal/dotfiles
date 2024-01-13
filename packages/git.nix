{ config, lib, pkgs, inputs, ... }:

{

  programs.git = {
    enable = true;

    config = {
      init.defaultBranch = "main";
    };
  };

}
