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

      qtile =
        let
          # BUG: overridePythonAttrs strips out the override function on the resulting derivation
          # this is a hacky way to get it back by composing overrides underneath the overridePythonAttrs
          # this means you can't overridePythonAttrs later down the line, but for our purposes it doesn't matter
          doOverrideAttrs =
            p:
            p.overridePythonAttrs (old: {
              src = inputs.qtile;
              # BUG: Invalid version for a Python package
              # version = versionFromInput inputs.qtile;
              patches = [ ];

              passthru = old.passthru // {
                providedSessions = [ "qtile-generic" ];
              };
            });

          doOverride =
            p: f:
            let
              next = p.override f;
              final = doOverrideAttrs next // {
                override = doOverride next;
              };
            in
            final;

          package = pythonPrev.qtile;
        in
        doOverrideAttrs package
        // {
          override = doOverride package;
        };

      qtile-extras = pythonPrev.qtile-extras.overridePythonAttrs {
        doCheck = false;
      };

      # Override Xonsh's source deeper in the package tree
      # Makes it easier to use Xonsh in Python environments
      xonsh = pythonPrev.xonsh.overridePythonAttrs (old: {
        src = inputs.xonsh;
        version = versionFromInput inputs.xonsh;

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

  # BUG: OIDC-Lite fails to build
  # Fix from: https://github.com/leo60228/dotfiles/blob/main/overlays/oidc-lite.nix
  hydra = prev.hydra.overrideAttrs (
    oldAttrs:
    let
      inherit (oldAttrs.passthru) perlDeps;
      newPerlDeps = perlDeps.override {
        paths = map (
          x:
          if x ? pname && x.pname == "OIDC-Lite" then
            x.overrideAttrs (oldAttrs: {
              doCheck = false;
            })
          else
            x
        ) perlDeps.paths;
      };
      patchInputs = inputs: map (x: if x.name == "hydra-perl-deps" then newPerlDeps else x) inputs;
    in
    {
      nativeBuildInputs = patchInputs oldAttrs.nativeBuildInputs;
      buildInputs = patchInputs oldAttrs.buildInputs;
      passthru.perlDeps = newPerlDeps;
    }
  );

  forgejo = latest.forgejo.overrideAttrs (old: {
    src = inputs.forgejo;
    version = versionFromInput inputs.forgejo;
    vendorHash = "sha256-sEQNmcSjtn9oKmy1gWNyUVPB9Vb5t+SHBaex9ueYOC0=";
    checkFlags = [
      # Requires network
      (builtins.head old.checkFlags + "|^TestActivityPubMatchesList$")
    ];
  });
}
