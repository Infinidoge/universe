channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    discord-canary
    ;

  inherit (channels.stable)
    nvfetcher
    ;

  # https://github.com/NixOS/nixpkgs/issues/167579
  python39Packages = prev.python39Packages.override
    (old: {
      overrides = prev.lib.composeExtensions (old.overrides or (_: _: { }))
        (py39final: py39prev: {
          inherit (channels.stable.python39Packages) pycurl;
        });
    });
}
