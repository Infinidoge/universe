{ stdenv
, lib
, fetchurl
, openjdk17
, gtk3
, makeWrapper
, wrapGAppsHook
}:

stdenv.mkDerivation (self: rec {
  pname = "setris";
  version = "1.2";

  # Since the file cannot be directly fetched, it must be added to the store manually
  # Add the file to the store with `nix store add-file Setris-1.2_LINUX.tar.gz`
  src = fetchurl {
    url = "download-from-itch/Setris-1.2_LINUX.tar.gz";
    sha256 = "sha256-slGBCJdMp+NjaPRf6x31Xi8T9L3kSR0vN39vawFHw2w=";
  };

  nativeBuildInputs = [
    gtk3
    makeWrapper
    wrapGAppsHook
  ];

  unpackPhase = ''
    tar xvf $src
  '';

  installPhase = ''
    mkdir -pv $out/share/java $out/bin
    cp setris-desktop-1.0-SNAPSHOT-jar-with-dependencies.jar $out/share/java/${self.pname}.jar
    makeWrapper ${openjdk17}/bin/java $out/bin/${self.pname} \
      --add-flags "-jar $out/share/java/${self.pname}.jar"
  '';

  meta = with lib; {
    homepage = "https://mslivo.itch.io/setris";
    description = "A Tetris-like game where the blocks turn into sand";
    license = licenses.unfree;
    platforms = platforms.all; # Uses a 'universal' jar
    maintainers = with maintainers; [ infinidoge ];
    broken = true;
  };
})
