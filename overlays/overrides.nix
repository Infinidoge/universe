channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    discord-canary
    kmscon
    prismlauncher

    # https://nixpk.gs/pr-tracker.html?pr=200098
    nitter
    ;

  inherit (channels.stable)
    hydrus
    ;

  qtile = final.qtile-unstable;
}
