final: prev:

let
  addPatches = package: patches: package.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ patches;
  });
in
{
  # coreutils-doge = addPatches prev.coreutils [ ./coreutils.patch ];
  coreutils-doge = prev.coreutils.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ [ ''gl_cv_host_operating_system=Doge/Linux'' ];
  });

  tailscale-doge = addPatches prev.tailscale [ ./tailscale-cgnat.patch ];
}
