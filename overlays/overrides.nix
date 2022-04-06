channels: final: prev: {

  __dontExport = true; # overrides clutter up actual creations

  inherit (channels.latest)
    cachix
    deploy-rs
    dhall
    discord
    discord-canary
    element-desktop
    kitty
    nixpkgs-fmt
    omnisharp-roslyn
    qutebrowser
    rage
    signal-desktop
    starship
    ;

  inherit (channels.latest)
    remarshal
    spice-gtk
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

  haskellPackages = prev.haskellPackages.override
    (old: {
      overrides = prev.lib.composeExtensions (old.overrides or (_: _: { })) (hfinal: hprev:
        let version = prev.lib.replaceChars [ "." ] [ "" ] prev.ghc.version;
        in
        {
          # same for haskell packages, matching ghc versions
          inherit (channels.latest.haskell.packages."ghc${version}")
            haskell-language-server;
        });
    });
}
