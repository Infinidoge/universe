{ stdenv
, lib
, fetchFromGitHub
, jre
, makeWrapper
, maven
}:

maven.buildMavenPackage rec {
  pname = "bytecode-viewer";
  version = "2.12";

  src = fetchFromGitHub {
    owner = "Konloch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-opAUmkEcWPOrcxAL+I1rBQXwHmvzbu0+InTnsg9r+z8=";
  };

  mvnHash = "sha256-mBTYQuybcFIm1KXYDXAk0+m5qEtmRQT7s/XsS50cV8s=";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp target/Bytecode-Viewer-${version}.jar $out/share/java/${pname}.jar

    makeWrapper ${jre}/bin/java $out/bin/bytecode-viewer \
      --add-flags "-Djava.security.manager=allow" \
      --add-flags "-jar $out/share/java/${pname}.jar"
  '';

  meta = with lib; {
    homepage = "https://github.com/Konloch/bytecode-viewer";
    description = "A Java 8+ Jar & Android APK Reverse Engineering Suite (Decompiler, Editor, Debugger & More) ";
    license = licenses.gpl3;
    platforms = platforms.all; # Uses a 'universal' jar
    maintainers = with maintainers; [ infinidoge ];
  };
}
