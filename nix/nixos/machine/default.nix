{
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
    {
      system.stateVersion = "23.11";
    }
  ];
}
