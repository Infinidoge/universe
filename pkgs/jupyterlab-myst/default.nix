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
  pname = "jupyterlab-myst";
  version = "0-unstable-2024-07-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-book";
    repo = "jupyterlab-myst";
    rev = "4c70b0312aee6f2f65c18d1aeec80521c1fa5bc3";
    hash = "sha256-Q7sQ2Al4/HCogGayYifBLX/yElDWS4wcTJVe4nFOQY8=";
  };

  patches = [
    ./add-tailwind-base-directive.patch
  ];

  prePatch = ''
    cp ${./yarn.lock} yarn.lock
    substituteInPlace package.json \
        --replace-fail '"@myst-theme/frontmatter": "^0.9.0"' '"@myst-theme/frontmatter": "^0.13.2"'
  '';


  yarnOfflineCache = fetchYarnDeps {
    yarnLock = ./yarn.lock;
    hash = "sha256-ou3Tjml5VU1O14k/oIDufj3QV2sQYD8EzVGAPhF9RZI=";
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
    substituteInPlace node_modules/@types/markdown-it/lib/index.d.ts \
        --replace 'readonly linkify: LinkifyIt.LinkifyIt;' 'readonly linkify: typeof LinkifyIt;'

    # Generate the jupyterlab extension files
    yarn --offline run build:prod
  '';

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "jupyterlab_myst" ];

  meta = with lib; {
    description = "Use MyST Markdown directly in Jupyter Lab";
    homepage = "https://github.com/jupyter-book/jupyterlab-myst";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}

