inputs: final: prev:
let
  mkPkgs = channel: channel.legacyPackages.${final.system};

  latest = mkPkgs inputs.latest;
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

  schildichat-desktop = prev.schildichat-desktop.override { electron = final.electron_25; };

  python3 = prev.python3.override {
    packageOverrides = pythonFinal: pythonPrev: {
      qtile = pythonPrev.qtile.overrideAttrs (oldAttrs: {
        version = "unstable-2023-09-30";
        src = oldAttrs.src.override {
          rev = "65693447ba6020919eed7c519efe76257161e80b";
          hash = "sha256-0JuJi1DyptChMyHWWDahK+oEqYYDHOdV3/bVtMr83CI=";
        };

        propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ (with pythonFinal; [ iwlib ]);
      });
    };
  };

  # https://nixpk.gs/pr-tracker.html?pr=259424
  autorandr = prev.autorandr.overrideAttrs (old: {
    meta = old.meta // { mainProgram = "autorandr"; };
  });
}
