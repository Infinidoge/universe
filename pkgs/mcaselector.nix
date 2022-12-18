{ stdenv
, lib
, fetchurl
, jre
, gtk3
, makeWrapper
, wrapGAppsHook
}:

stdenv.mkDerivation (self: rec {
  pname = "mcaselector";
  version = "2.1";

  src = fetchurl {
    url = "https://github.com/Querz/mcaselector/releases/download/${version}/mcaselector-${version}.jar";
    sha256 = "sha256-6byZ3kH+iLAv2NZ2MzMvwlJ/RFNk4jl4RnT2S0Ctu90=";
  };

  dontUnpack = true;

  nativeBuildInputs = [
    gtk3
    makeWrapper
    wrapGAppsHook
  ];

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp ${src} $out/share/java/${self.pname}.jar

    makeWrapper ${jre}/bin/java $out/bin/mcaselector \
      --add-flags "-jar $out/share/java/${self.pname}.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/Querz/mcaselector";
    description = "A tool to select chunks from Minecraft worlds for deletion or export. ";
    license = licenses.mit;
    platforms = platforms.all; # Uses a 'universal' jar
    maintainers = with maintainers; [ infinidoge ];
  };
})
