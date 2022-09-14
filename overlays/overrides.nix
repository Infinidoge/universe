channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  # Pin discord-canary version for powercord
  # powercord = prev.powercord.override { inherit (channels.fork) discord-canary; };

  inherit (channels.latest)
    discord-canary
    polymc
    kmscon
    ;

  inherit (channels.stable)
    hydrus
    ;

}
