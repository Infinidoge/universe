{ buildPythonPackage
, fetchFromGitHub

, yarnConfigHook
, fetchYarnDeps

, jupyterlab
, jupyter
, jupyter-packaging
, hatchling
, hatch-jupyter-builder
, hatch-nodejs-version
, nodejs
}:

buildPythonPackage rec {
  pname = "jupyterlab-vpython";
  version = "0-unstable-2024-03-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jcoady";
    repo = "jupyterlab_vpython";
    rev = "6a217306bb3fea48cb04ae0e6980b871bae5c626";
    hash = "sha256-yST604b5UAk+vPb0R8weI+ufuZFQTr6+MYUkX013s6I=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-/t97A2uUjtas7KBQXaK+lm0GXAtHOlT976G/qQpKN1Y=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
  ];

  build-system = [
    hatchling
    hatch-jupyter-builder
    hatch-nodejs-version
    jupyterlab
    jupyter
    jupyter-packaging
  ];

  dependencies = [
    jupyterlab
    jupyter
    jupyter-packaging
  ];

  prePatch = ''
    cp ${./yarn.lock} yarn.lock
  '';

  preConfigure = ''
    substituteInPlace package.json \
        --replace-fail 'jlpm' 'yarn'
  '';

  preBuild = ''
    # Generate the jupyterlab extension files
    yarn --offline run build:prod
  '';
}
