channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    # discord-canary
    kmscon
    prismlauncher
    ;

  inherit (channels.fork)
    # https://nixpk.gs/pr-tracker.html?pr=229173
    discord-canary
    ;

  inherit (channels.stable)
    hydrus
    ;

  qtile = final.qtile-unstable;
}
