{ lib
, buildPythonPackage
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
  pname = "jupyterlab-vim";
  version = "4.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterlab-contrib";
    repo = "jupyterlab-vim";
    rev = "v${version}";
    hash = "sha256-VIT60kiBSYfGQ23aiFjpcAdDdpLseOvFPL64dQplkr8=";
  };

  prePatch = ''
    cp ${./yarn.lock} yarn.lock
  '';


  yarnOfflineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-z82r763EG+QGu2KbZ2PaKueAs9wrpTYul/O/O7It7lY=";
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

  preConfigure = ''
    substituteInPlace package.json \
        --replace-fail 'jlpm' 'yarn'
  '';

  preBuild = ''
    # Generate the jupyterlab extension files
    yarn --offline run build:prod
  '';


  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "jupyterlab_vim" ];

  meta = with lib; {
    description = "Vim notebook cell bindings for JupterLab";
    homepage = "https://github.com/jupyterlab-contrib/jupterlab-vim";
    license = licenses.mit;
    maintainers = [ ];
  };
}

