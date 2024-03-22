{ stdenvNoCC, fetchFromGitHub, lib }:

stdenvNoCC.mkDerivation {
  pname = "ponder";
  version = "unstable-2022-12-15";

  src = fetchFromGitHub {
    owner = "codazoda";
    repo = "ponder";
    rev = "5eb224e8c0fb305aee931b460c48511ef4d87501";
    sha256 = "sha256-h2c8m6swt1jh1c99qkLp6fI7G6qhHHsj2df0XU3K08k=";
  };

  patches = [ ./dark-mode.patch ];

  preferLocalBuild = true;

  installPhase = ''
    mkdir -p $out
    cp -r ./app/* $out
    rm $out/ponder.zip
  '';

  meta = with lib; {
    license = licenses.mit;
  };
}
