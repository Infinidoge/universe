{ stdenv
, fetchurl
, makeWrapper
, lib
, jre
}:
stdenv.mkDerivation rec {
  pname = "unbted";
  version = "1.1";

  src = fetchurl {
    url = "https://github.com/unascribed/unbted/releases/download/v${version}/unbted-${version}.jar";
    sha256 = "sha256-Sn6dQV4oCcpYdpa6Cvmese5FqgJ0z9WdVx5GNIMULno=";
  };
  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${src} $out/share/java/${pname}-${version}.jar
    makeWrapper ${jre}/bin/java $out/bin/${pname} \
      --add-flags "-jar $out/share/java/${pname}-${version}.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/unascribed/unbted";
    description = "Una's NBT Editor - an advanced interactive command-line NBT editor";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ infinidoge ];
  };
}