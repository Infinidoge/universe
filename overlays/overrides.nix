inputs: final: prev:
let
  mkPkgs = channel: channel.legacyPackages.${final.system};
  mkPkgsUnfree = channel: import channel {
    inherit (final) system;
    config.allowUnfree = true;
  };

  latest = mkPkgsUnfree inputs.latest;
  fork = mkPkgs inputs.fork;
  stable = mkPkgs inputs.stable;
in
{
  inherit latest fork stable;

  inherit (latest)
    vencord
    ;

  inherit (fork)
    ;

  inherit (stable)
    nix-melt
    ;

  schildichat-desktop = stable.schildichat-desktop.override { electron = final.electron_30; };

  python3 = prev.python3.override {
    packageOverrides = pythonFinal: pythonPrev: {
      qtile = pythonPrev.qtile.overrideAttrs (oldAttrs: {
        version = "0.0.0+unstable-2024-06-25";
        src = oldAttrs.src.override {
          rev = "dfb7186eed9253fff9958877bb3fe1e5e0ffcf32";
          hash = "sha256-1mvS/bvXDplkiG7GzDFu9cEFV9onbvNTYbhb4W1qj+0=";
        };
      });
    };
  };

  qtile = prev.qtile.overrideAttrs {
    version = final.python3Packages.qtile.version;
  };

  python-grip = fork.python3Packages.grip;

  factorio-headless = latest.factorio-headless.overrideAttrs (old: {
    meta = old.meta // { mainProgram = "factorio"; };
  });

  compsize = prev.compsize.override {
    btrfs-progs = final.btrfs-progs.overrideAttrs rec {
      version = "6.10";
      src = final.fetchurl {
        url = "mirror://kernel/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${version}.tar.xz";
        hash = "sha256-M4KoTj/P4f/eoHphqz9OhmZdOPo18fNFSNXfhnQj4N8=";
      };
    };
  };
}
