channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    discord-canary
    kmscon
    prismlauncher
    ;

  inherit (channels.stable)
    hydrus
    ;

  inherit (channels.fork)
    nitter
    ;

  qtile = final.qtile-unstable;
}
