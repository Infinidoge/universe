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
    factorio-headless
    hydrus
    ;

  inherit (fork)
    ;

  inherit (stable)
    nix-melt
    ;

  gum = latest.gum.overrideAttrs (old: {
    src = old.src.override {
      rev = "0f8f67f96e52159bc9645a9ffab4004658e4fdc6";
      hash = "sha256-Ib7ZbRJ4hOdV+bfNQSQwYcDsHh/gWyweTV69UhG8DY0=";
    };
    vendorHash = "sha256-tg1cJoHy5gE/45IIN+wxltQOhr8voToWyBss0+dUhg4=";
  });

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
      hash = "sha256-vVzERis1W3QZB/i6SQR9dQR56yDWadKWvFr+nLTQY9Y=";
    };
  });

  schildichat-desktop = stable.schildichat-desktop.override { electron = final.electron; };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pythonFinal: pythonPrev: {
      inherit (final) jupyterlab-vim jupyterlab-myst;

      qtile = pythonPrev.qtile.overrideAttrs (oldAttrs: {
        version = "0.0.0+unstable-2024-11-28";
        src = oldAttrs.src.override {
          rev = "4897d0d15d4403de00d19c570d60178541c7c582";
          hash = "sha256-k0kxvPUOEb6/1HnihRhPcULO+AI8PPvtX3SBt3EImI8=";
        };
      });
      qtile-extras = pythonPrev.qtile-extras.overridePythonAttrs {
        doCheck = false;
      };

      # https://github.com/NixOS/nixpkgs/pull/356680/
      term-image = pythonPrev.term-image.overridePythonAttrs {
        pythonRelaxDeps = [ "pillow" ];
      };
    })
  ];

  qtile = prev.qtile.overrideAttrs {
    version = final.python3Packages.qtile.version;
  };

  python-grip = fork.python3Packages.grip;
}
