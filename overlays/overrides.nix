channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    discord-canary
    ;

  inherit (channels.stable)
    # FIXME: https://github.com/NixOS/nixpkgs/issues/167785
    firefox
    ;

  # https://github.com/NixOS/nixpkgs/issues/167579
  python39Packages = prev.python39Packages.override
    (old: {
      overrides = prev.lib.composeExtensions (old.overrides or (_: _: { }))
        (py39final: py39prev: {
          inherit (channels.latest.python39Packages) pycurl;
        });
    });
}
