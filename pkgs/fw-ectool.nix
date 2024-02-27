{ stdenv
, lib
, fetchFromGitLab
, pkg-config
, cmake
, hostname
, libusb1
, libftdi1
}:

stdenv.mkDerivation {
  pname = "fw-ectool";
  version = "unstable-2024-01-03";

  src = fetchFromGitLab {
    domain = "gitlab.howett.net";
    owner = "DHowett";
    repo = "ectool";
    rev = "3ebe7b8b713b2ebfe2ce92d48fd8d044276b2879";
    hash = "sha256-s6PrFPAL+XJAENqLw5oJqFmAf11tHOJ8h3F5l3pOlZ4=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    hostname
  ];

  buildInputs = [
    libusb1
    libftdi1
  ];

  buildPhase = ''
    make ectool
  '';

  installPhase = ''
    install -D src/ectool $out/bin/ectool
  '';

  meta = with lib; {
    description = "EC-Tool adjusted for usage with framework embedded controller";
    homepage = "https://github.com/DHowett/framework-ec";
    license = licenses.bsd3;
    maintainers = [ maintainers.mkg20001 ];
    platforms = platforms.linux;
    mainProgram = "ectool";
  };
}
