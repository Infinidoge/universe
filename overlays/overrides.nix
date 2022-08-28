channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  # Pin discord-canary version for powercord
  # powercord = prev.powercord.override { inherit (channels.fork) discord-canary; };

  inherit (channels.latest)
    polymc
    kmscon
    ;

  inherit (channels.stable)
    hydrus
    ;

  qtile = prev.qtile.override {
    python3 = final.python310;
    python3Packages = final.python310Packages;
  };
}
