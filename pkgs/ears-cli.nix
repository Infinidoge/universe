{ lib
, stdenv
, fetchFromGitea
, makeWrapper
, jdk
}:
stdenv.mkDerivation rec {
  pname = "ears-cli";
  version = "unstable-2023-04-24";

  src = fetchFromGitea {
    domain = "git.sleeping.town";
    owner = "feline";
    repo = "ears-cli";
    rev = "deb1a0da3377a5ff2da8e7e325eb6ba783b28137";
    sha256 = "sha256-Xn+RbgTn2Qvx1ztorUuoOMnvrlVmfg0ELmEDyFGv/3c=";
  };

  nativeBuildInputs = [ jdk makeWrapper ];

  buildPhase = ''
    bash ./build.sh
  '';

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${pname}.jar $out/share/java/${pname}-${version}.jar
    makeWrapper ${jdk}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}-${version}.jar"
  '';

  meta = with lib; {
    homepage = "https://git.sleeping.town/feline/ears-cli";
    description = "A tool to manipulate Ears skins on the command line";
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinidoge ];
  };
}
