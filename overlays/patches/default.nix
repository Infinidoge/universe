final: prev:

let
  addPatches =
    package: patches:
    package.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ patches;
    });
in
{
  # coreutils-doge = addPatches prev.coreutils [ ./coreutils.patch ];
  coreutils-doge = prev.coreutils.overrideAttrs (old: {
    configureFlags = old.configureFlags ++ [ "gl_cv_host_operating_system=Doge/Linux" ];
  });

  tailscale-doge = prev.tailscale.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./tailscale-cgnat.patch ];
    doCheck = false; # patch causes some tests to fail
  });

  #fprintd = addPatches prev.fprintd [
  #  (final.fetchpatch {
  #    url = "https://gitlab.freedesktop.org/libfprint/fprintd/-/commit/8a8162daa2fb08210ecc4c48d1f10ee97cc7a088.patch";
  #    hash = "sha256-05tNiv2wdztkjBBiBS5hpuC5n3QrsJ5o15Uv7Q42on4=";
  #  })
  #];

  hydra_unstable = addPatches prev.hydra_unstable [
    ./hydra-force-allow-import-from-derivation.patch
  ];

  openssh-srv = addPatches prev.openssh [ ./srv-records.patch ];

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pythonFinal: pythonPrev: {
      ldap3 = addPatches pythonPrev.ldap3 [ ./ldap3.patch ];
    })
  ];

  discordchatexporter-cli = addPatches prev.discordchatexporter-cli [
    (final.fetchpatch {
      url = "https://github.com/Tyrrrz/DiscordChatExporter/commit/7be46d6de5fe3d2cd9f957c53c50d7e619bec18a.patch";
      hash = "sha256-UbS4RpKbjo7cdO0sY0ggpadqD0Hln1jNK0WG0k8M0Ao=";
    })
  ];
}
