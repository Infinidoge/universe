{
  buildPythonPackage,
  fetchFromGitHub,

  cython,
  setuptools,
  setuptools-scm,

  autobahn,
  ipykernel,
  jupyter,
  notebook,
  numpy,
  jupyterlab-vpython,
}:

buildPythonPackage {
  pname = "vpython-jupyter";
  version = "7.6.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vpython";
    repo = "vpython-jupyter";
    tag = "7.6.5";
    hash = "sha256-k8cBeOU2ePLM+3f+0FHLiK4kejZ2ZSNbCdgYsG00xsg=";
  };

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];
  dependencies = [
    autobahn
    ipykernel
    jupyter
    notebook
    numpy
    jupyterlab-vpython
  ];

  preConfigure = ''
    substituteInPlace setup.py \
        --replace-fail "'jupyter-server-proxy', " ""
  '';
}
