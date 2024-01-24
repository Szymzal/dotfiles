{ pkgs, ... }: {
  home.username = "szymzal";
  home.homeDirectory = "/home/szymzal";

  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    # Neovim
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

  home.file = {
    ".config/nvim".source = ../../configs/nvim;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
