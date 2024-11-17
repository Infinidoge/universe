inputs: final: prev:
let
  mkPkgs = channel: channel.legacyPackages.${final.system};
  mkPkgsUnfree = channel: import channel {
    inherit (final) system;
    config.allowUnfree = true;
  };

  latest = mkPkgsUnfree inputs.latest;
  fork = mkPkgsUnfree inputs.fork;
  stable = mkPkgs inputs.stable;

  versionFromInput = input:
    let
      slice = a: b: builtins.substring a b input.lastModifiedDate;
    in
    "0-unstable-${slice 0 5}-${slice 5 7}-${slice 7 9}";
in
{
  inherit latest fork stable;

  inherit (latest)
    bitwarden-desktop
    immich
    immich-machine-learning
    factorio-headless
    ;

  inherit (fork)
    ;

  inherit (stable)
    nix-melt
    ;

  vencord = latest.vencord.overrideAttrs (old: rec {
    src = inputs.vencord;
    version = versionFromInput inputs.vencord;
    env = old.env // {
      VENCORD_REMOTE = "Vendicated/Vencord";
      VENCORD_HASH = builtins.substring 0 9 inputs.vencord.rev;
    };
    pnpmDeps = final.pnpm.fetchDeps {
      inherit (old) pname;
      inherit src;
      hash = "sha256-kUfCTF/HKHmsxzWyT6XK833+4A2RUBJcxx6lZsRSTn0=";
    };
  });

  schildichat-desktop = stable.schildichat-desktop.override { electron = final.electron_30; };

  python3 = prev.python3.override {
    packageOverrides = pythonFinal: pythonPrev: {
      inherit (latest.python3Packages) pymdown-extensions onnx;
      inherit (final) jupyterlab-vim jupyterlab-myst;

      qtile = pythonPrev.qtile.overrideAttrs (oldAttrs: {
        version = "0.0.0+unstable-2024-06-25";
        src = oldAttrs.src.override {
          rev = "dfb7186eed9253fff9958877bb3fe1e5e0ffcf32";
          hash = "sha256-1mvS/bvXDplkiG7GzDFu9cEFV9onbvNTYbhb4W1qj+0=";
        };
      });
      qtile-extras = pythonPrev.qtile-extras.overridePythonAttrs {
        doCheck = false;
      };
    };
  };

  qtile = prev.qtile.overrideAttrs {
    version = final.python3Packages.qtile.version;
  };

  python-grip = fork.python3Packages.grip;
}
