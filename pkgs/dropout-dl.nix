{
  stdenv,
  fetchFromGitHub,
  cmake,

  curl,
}:

stdenv.mkDerivation rec {
  pname = "dropout-dl";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "mosswg";
    repo = "dropout-dl";
    tag = "v${version}";
    hash = "sha256-fN5RRDa+IDAT9uXpiEEaBRMXHOn7ZY4R1iqXJ9kpla8=";
    fetchSubmodules = true;
  };

  installPhase = ''
    install -m555 -D -t $out/bin dropout-dl
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ curl ];
}
