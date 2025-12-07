inputs: final: prev:
let
  mkPkgs = channel: channel.legacyPackages.${final.system};
  mkPkgsUnfree =
    channel:
    import channel {
      inherit (final) system;
      config.allowUnfree = true;
    };

  latest = mkPkgsUnfree inputs.latest;
  fork = mkPkgsUnfree inputs.fork;
  stable = mkPkgs inputs.stable;
  old-stable = mkPkgs inputs.old-stable;

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
    discord
    discord-canary
    bitwarden-desktop
    factorio-headless
    hydrus
    presenterm
    flameshot
    immich
    ;

  inherit (fork)
    discordchatexporter-cli
    ;

  inherit (stable)
    nix-melt
    bitwarden-cli
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
    postPatch = old.postPatch + ''
      sed -i '/export const CspPolicies/a "inx.moe": ImageScriptsAndCssSrc,' src/main/csp/index.ts
    '';
    #pnpmDeps =
    #  (latest.pnpm_10.fetchDeps {
    #    inherit (old) pname;
    #    inherit version src;
    #    fetcherVersion = 2;
    #    hash = "";
    #  }).overrideAttrs
    #    { inherit (old) patches postPatch; };
  });

  schildichat-desktop = old-stable.schildichat-desktop.override { electron = final.electron; };

  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (pythonFinal: pythonPrev: {
      inherit (final)
        jupyterlab-vim
        jupyterlab-myst
        jupyterlab-vpython
        vpython-jupyter
        jupyter-server-proxy
        ;

      qtile-extras = pythonPrev.qtile-extras.overridePythonAttrs {
        doCheck = false;
      };
    })
  ];

  homebox = latest.homebox.overrideAttrs (o: rec {
    version = "0.22.0-rc.2";
    src = o.src.override {
      tag = "v${version}";
      hash = "sha256-ZU0uOisSW4yeI0ZLFICVk84hBzoZqCoyRlwaqzXssp4=";
    };
    pnpmDeps = o.pnpmDeps.override {
      inherit version;
      src = "${src}/frontend";
      hash = "sha256-Pz0USL9/kLPFFBo3uWtZTcgSyuuf3uaFqHTwIJh4i1c=";
    };
    vendorHash = "sha256-xxR0cl0+vDGVoblGSFwvJGZFm5KNp9ZhAchdUl1DbFI=";
  });

  # BUG: https://github.com/NixOS/nixpkgs/issues/358845
  # Weirdly, only a problem at evaluation
  openjfx = prev.openjfx.override { gradle_7 = final.gradle_8; };
  openjfx17 = prev.openjfx17.override { gradle_7 = final.gradle_8; };
  openjfx21 = prev.openjfx21.override { gradle_7 = final.gradle_8; };
}
