channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    # discord-canary
    kmscon
    prismlauncher
    ;

  inherit (channels.fork)
    # https://nixpk.gs/pr-tracker.html?pr=234673
    nitter
    ;

  inherit (channels.stable)
    hydrus
    ;

  qtile = final.qtile-unstable;
}
