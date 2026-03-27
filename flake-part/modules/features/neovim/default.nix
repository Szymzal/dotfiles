{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.neovim =
      (inputs.nvf.lib.neovimConfiguration {
        inherit pkgs;
        modules = [self.nixosModules.neovimConfig];
      }).neovim;
  };
}
