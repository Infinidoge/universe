{ config, lib, ... }:
with lib;
{
  options.info = {
    monitors = mkOption {
      type = types.int;
      default = 1;
    };
  };
}
