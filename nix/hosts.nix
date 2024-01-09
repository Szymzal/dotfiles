let

  createHost = { type, hostPlatform, homeDir ? null }:
    if type == "nixos" then
      { inherit type hostPlatform; }
    else if type == "home-manager" then
      assert homeDir != null;
      { inherit type hostPlatform homeDir; }
    else throw "Unknown host type '${type}'";

in
{

  machine = createHost {
    type = "nixos";
    hostPlatform = "x86_64-linux";
  };

  wsl = createHost {
    type = "nixos";
    hostPlatform = "x86_64-linux";
  };

}
