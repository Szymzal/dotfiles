{ pkgs, ... }: {
  home.packages = with pkgs; [
    obsidian
  ];

  mypackages.impermanence = {
    directories = [
      ".config/obsidian"
      "Notes"
    ];
  };
}
