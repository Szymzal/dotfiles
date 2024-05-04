{ config, ... }:
let
  mkThrow = condition: message:
    (if (condition) then true else throw "${message}");
  mkThrowNull = item: message:
    (config.lib.myLib.mkThrow (item != null) message);
in
{
  lib.myLib = {
    inherit
      mkThrow
      mkThrowNull;
  };
}
