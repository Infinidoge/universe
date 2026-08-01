{ lib, ... }:
{
  options = {
    info = lib.our.mkOpt lib.types.attrs { };
    common = lib.our.mkOpt lib.types.attrs { };
  };
}
