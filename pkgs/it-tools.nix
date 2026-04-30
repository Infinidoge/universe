{
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  pnpmConfigHook,
  fetchPnpmDeps,
}:
let
  pnpm = pnpm_9;
in

stdenvNoCC.mkDerivation rec {
  pname = "it-tools";
  version = "0-unstable-2024-12-14";

  src = fetchFromGitHub {
    owner = "CorentinTh";
    repo = "it-tools";
    rev = "08d977b8cdb7ffb76adfa18ba6eb4b73795ec814";
    hash = "sha256-Zfw3eoyfxIcyjcIJYpPN8RScFmvFBu8KDiqcahUwVjw=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share
    cp -r dist/* $out/share/
    runHook postInstall
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    fetcherVersion = 3;
    hash = "sha256-qMZ22uJ8Ibi7Cft56gwauBYDXQTJuWsXY8yAwbJ052Y=";
  };
}
