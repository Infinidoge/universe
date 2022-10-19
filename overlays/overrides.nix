channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    discord-canary
    kmscon
    ;

  inherit (channels.stable)
    hydrus
    ;

  qtile = final.qtile-unstable;
}
