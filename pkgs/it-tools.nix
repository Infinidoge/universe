{
  stdenvNoCC,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
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
    pnpm.configHook
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

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    fetcherVersion = 1;
    hash = "sha256-cYx9nafA/GbCGIC5Ofqu6T8F2d1UDcK+0jzZR81dS/0=";
  };
}
