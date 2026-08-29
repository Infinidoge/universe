inputs: final: prev:
let
  inherit (prev.stdenv.hostPlatform) system;

  mkPkgs = channel: channel.legacyPackages.${system};
  mkPkgsUnfree =
    channel:
    import channel {
      inherit system;
      config.allowUnfree = true;
    };

  latest = mkPkgsUnfree inputs.latest;
  fork = mkPkgsUnfree inputs.fork;
  stable = mkPkgs inputs.stable;

  versionFromInput =
    input:
    let
      slice = a: b: builtins.substring a b input.lastModifiedDate;
    in
    "0-unstable-${slice 0 5}-${slice 5 7}-${slice 7 9}";
in
{
  inherit latest fork stable;

  inherit (latest)
    bind
    bitwarden-desktop
    bluesky-pds
    borgbackup
    discord
    discord-canary
    factorio-headless
    firefox-devedition
    flameshot
    immich
    presenterm
    vaultwarden
    weblate
    yt-dlp
    ;

  inherit (stable)
    ;

  gum = latest.gum.overrideAttrs (old: {
    src = old.src.override {
      rev = "0f8f67f96e52159bc9645a9ffab4004658e4fdc6";
      hash = "sha256-Ib7ZbRJ4hOdV+bfNQSQwYcDsHh/gWyweTV69UhG8DY0=";
    };
    vendorHash = "sha256-tg1cJoHy5gE/45IIN+wxltQOhr8voToWyBss0+dUhg4=";
  });

  vencord = latest.vencord.overrideAttrs (old: rec {
    #src = inputs.vencord;
    #version = versionFromInput inputs.vencord;
    #env = old.env // {
    #  VENCORD_REMOTE = "Vendicated/Vencord";
    #  VENCORD_HASH = builtins.substring 0 9 inputs.vencord.rev;
    #};
    postPatch = old.postPatch + ''
      sed -i '/export const CspPolicies/a "inx.moe": ImageScriptsAndCssSrc,' src/main/csp/index.ts
    '';
    #pnpmDeps =
    #  (latest.pnpm_10.fetchDeps {
    #    inherit (old) pname;
    #    inherit version src;
    #    fetcherVersion = 4;
    #    hash = "";
    #  }).overrideAttrs
    #    { inherit (old) patches postPatch; };
  });

  qtile = prev.qtile.overridePythonAttrs {
    # BUG: https://github.com/qtile/qtile/issues/5766
    doCheck = false;
  };

  # NOTE: Inheriting Python packages from different nixpkgs versions is unsupported
  # Doing this leads to an error saying:
  # "should use `buildPythonPackage` or `toPythonModule` if it is to be part of the Python packages set."

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pythonFinal: pythonPrev: {
      inherit (final)
        jupyter-server-proxy
        jupyterlab-myst
        jupyterlab-vim
        ;

      qtile-extras = pythonPrev.qtile-extras.overridePythonAttrs {
        doCheck = false;
      };

      # Override Xonsh's source deeper in the package tree
      # Makes it easier to use Xonsh in Python environments
      xonsh = pythonPrev.xonsh.overridePythonAttrs (old: {
        version = versionFromInput inputs.xonsh;
        src = inputs.xonsh;

        disabledTests = old.disabledTests ++ [
          "test_bash_completion_paths_llm"
        ];
        disabledTestPaths = old.disabledTestPaths ++ [
          "tests/xintegration/test_integrations.py"
        ];
      });
    })
  ];

  # BUG: https://github.com/NixOS/nixpkgs/issues/464244
  hydrus = latest.hydrus.overrideAttrs (o: {
    doCheck = false;
    doInstallCheck = false;
    propagatedBuildInputs = builtins.filter (
      dep: dep != latest.python3Packages.psd-tools
    ) o.propagatedBuildInputs;
  });

  bespokesynth = prev.bespokesynth.overrideAttrs (o: {
    src = final.fetchFromGitHub {
      inherit (o.src) owner repo fetchSubmodules;
      rev = "7df1d9236514772a7ab8a038846c8ef0515bfec1";
      hash = "sha256-LsTqUrAlTZuJ0sXOh/vNyOxM3troHALYqK54hI3bw0g=";
    };
  });

  lix = prev.lix.overrideAttrs (o: {
    # BUG: https://git.lix.systems/lix-project/lix/issues/1250
    doCheck = false;
  });

  forgejo = latest.forgejo.overrideAttrs {
    src = inputs.forgejo;
    version = versionFromInput inputs.forgejo;
  };
}
