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
    ;

  schildichat-desktop = stable.schildichat-desktop.override { electron = final.electron_30; };

  python3 = prev.python3.override {
    packageOverrides = pythonFinal: pythonPrev: {
      qtile = pythonPrev.qtile.overrideAttrs (oldAttrs: {
        version = "0.0.0+unstable-2024-03-13";
        src = oldAttrs.src.override {
          rev = "c4d3c6e602f9ed619086cc3942bd1c47ebabedbf";
          hash = "sha256-1mvS/bvXDplkiG7GzDFu9cEFV9onbvNTYbhb4W1qj+0=";
        };
      });
    };
  };

  python-grip = fork.python3Packages.grip;

  factorio-headless = latest.factorio-headless.overrideAttrs (old: {
    meta = old.meta // { mainProgram = "factorio"; };
  });
}
