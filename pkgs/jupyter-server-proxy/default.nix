{
  buildPythonPackage,
  fetchFromGitHub,

  yarnConfigHook,
  fetchYarnDeps,
  hatchling,
  hatch-jupyter-builder,
  nodejs,

  jupyterlab,
  aiohttp,
  importlib-metadata,
  jupyter-server,
  simpervisor,
  tornado,
  traitlets,
}:

buildPythonPackage {
  pname = "jupyter-server-proxy";
  version = "4.4.1-0.dev";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "jupyter-server-proxy";
    rev = "44db8eec5b0fb7f4f842f3f30b9c17b5ed2ceec5";
    hash = "sha256-AQr14CK/aT5rB46jmGzEATI6R/QoMt7RKUBSnoQuDzE=";
  };

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-9zErE3SFrt7O7nKzRSX5Lup3z7b1c8GSCAMpF7hkiOU=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
  ];

  build-system = [
    hatchling
    hatch-jupyter-builder
    jupyterlab
  ];

  dependencies = [
    aiohttp
    importlib-metadata
    jupyter-server
    simpervisor
    tornado
    traitlets
  ];

  preConfigure = ''
    substituteInPlace labextension/package.json \
        --replace-fail 'jlpm' 'yarn'
    pushd labextension
    cp ${./yarn.lock} yarn.lock
  '';

  preBuild = ''
    # Generate the jupyterlab extension files
    yarn --offline run build:prod
    popd
  '';
}
