{ config, lib, ... }:
with lib;
with lib.hlissner;
{
  options = { };
  config = mkMerge [
    {
      networking.useDHCP = false;
    }
  ];
}
