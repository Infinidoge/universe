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

  #fprintd = addPatches prev.fprintd [
  #  (final.fetchpatch {
  #    url = "https://gitlab.freedesktop.org/libfprint/fprintd/-/commit/8a8162daa2fb08210ecc4c48d1f10ee97cc7a088.patch";
  #    hash = "sha256-05tNiv2wdztkjBBiBS5hpuC5n3QrsJ5o15Uv7Q42on4=";
  #  })
  #];

  hyfetch = addPatches prev.hyfetch [ ./neofetch-remove-steam-packages.patch ];

  hydra_unstable = addPatches prev.hydra_unstable [ ./hydra-force-allow-import-from-derivation.patch ];

  openssh-srv = addPatches prev.openssh [ ./srv-records.patch ];
}
