{ config, lib, ... }:
with lib;
{
  options.info = {
    monitors = mkOption {
      type = types.int;
      default = 1;
    };

    graphical = mkOption {
      type = with types; bool;
      default = false;
      description = "Whether or not we are in a graphical environment";
    };
  };

  config = {
    info.graphical = config.services.xserver.enable;
  };
}
