channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  # Pin discord-canary version for powercord
  # powercord = prev.powercord.override { inherit (channels.fork) discord-canary; };

  inherit (channels.latest)
    polymc
    ;

  # https://github.com/NixOS/nixpkgs/issues/167579
  python39Packages = prev.python39Packages.override
    (old: {
      overrides = prev.lib.composeExtensions (old.overrides or (_: _: { }))
        (py39final: py39prev: {
          inherit (channels.latest.python39Packages) pycurl;
        });
    });

  qtile = prev.qtile.override {
    python3 = final.python310;
    python3Packages = final.python310Packages;
  };
}
