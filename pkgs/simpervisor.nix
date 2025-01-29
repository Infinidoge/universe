{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
}:

buildPythonPackage {
  pname = "simpervisor";
  version = "0-unstable-2024-03-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyterhub";
    repo = "simpervisor";
    rev = "f29189ec6eb961caa5b26782cac1645db074ddce";
    hash = "sha256-rmEQ68Ll1cIzQrYXHTkLYVxog3kPkieExJ1xBTeQ2nc=";
  };

  build-system = [
    hatchling
  ];
}
