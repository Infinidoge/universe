{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "unmap";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "chbrown";
    repo = "unmap";
    rev = "v${version}";
    sha256 = "sha256-Q/20Y3AmAW6yc98ZuUkbHz2F2pH5qxi7fHffilp2Qxw=";
  };

  dontNpmBuild = true;

  patches = [ ./unmap-add-package-lock.patch ];

  npmDepsHash = "sha256-kZsd+57JMLu4syAD85F5ihapRGy8YekLhtpwRqk+Izs=";
}
