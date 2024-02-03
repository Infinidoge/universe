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
        version = "unstable-2023-10-29";
        src = oldAttrs.src.override {
          rev = "01ebe18db896dd0aef05f06b0dedf0141a2b50cf";
          hash = "sha256-P/3Kby5W2hKQ4mmR7mgsT8twhJc3QfI231tIlJWmNAo=";
        };
      });
    };
  };

  factorio-headless = latest.factorio-headless.overrideAttrs (old: {
    meta = old.meta // { mainProgram = "factorio"; };
  });
}
