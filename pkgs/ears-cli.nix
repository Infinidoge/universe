{ lib
, stdenvNoCC
, fetchFromGitea
, makeWrapper
, jdk
}:
stdenvNoCC.mkDerivation rec {
  pname = "ears-cli";
  version = "unstable-2023-08-24";

  src = fetchFromGitea {
    domain = "git.sleeping.town";
    owner = "feline";
    repo = "ears-cli";
    rev = "c54eac4f6a980908d6cde1abf9d9228615c1d71b";
    sha256 = "sha256-3ov7wjw8nxjwrNRH0wHICbZjXR4j2DPkUl5WlxJZsLA=";
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
    inherit (jdk.meta) platforms;
    maintainers = with maintainers; [ infinidoge ];
  };
}
