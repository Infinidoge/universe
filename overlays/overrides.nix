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
    ;

  inherit (fork)
    ;

  inherit (stable)
    ;

  schildichat-desktop = stable.schildichat-desktop.override { electron = final.electron_26; };

  python3 = prev.python3.override {
    packageOverrides = pythonFinal: pythonPrev: {
      qtile = pythonPrev.qtile.overrideAttrs (oldAttrs: {
        version = "0.0.0+unstable-2024-02-14";
        src = oldAttrs.src.override {
          rev = "bdfacffc56755d507c11359db0fb30a5768002f6";
          hash = "sha256-9q+I6HvZqg54eh4WoKR3H9fjTLGktk5vdvo7qTAVLok=";
        };
      });
    };
  };

  python-grip = fork.python3Packages.grip;

  factorio-headless = latest.factorio-headless.overrideAttrs (old: {
    meta = old.meta // { mainProgram = "factorio"; };
  });
}
