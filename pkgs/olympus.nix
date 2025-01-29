# Taken from https://github.com/VergeDX/config-nixpkgs/blob/899f13750c9c1795d455eeee9cb28d3aa74a0866/packages/gui/olympus.nix
{
  stdenv,
  lib,
  fetchzip,
  unzip,
  makeDesktopItem,
  buildFHSEnv,
}:
let
  olympus = stdenv.mkDerivation rec {
    pname = "olympus";
    version = "4084";

    # https://everestapi.github.io/
    src = fetchzip {
      url = "https://dev.azure.com/EverestAPI/Olympus/_apis/build/builds/${version}/artifacts?artifactName=linux.main&$format=zip#linux.main.zip";
      hash = "sha256-tKnMF7+KlEuQ15pBwV31s+R27oDLiKTLXgqmlLAKMhM=";
    };

    buildInputs = [ unzip ];
    installPhase = ''
      mkdir -p "$out/opt/olympus/"
      mv dist.zip "$out/opt/olympus/" && cd "$out/opt/olympus/"
      unzip dist.zip && rm dist.zip
      mkdir $out && echo XDG_DATA_HOME=$out
      echo y | XDG_DATA_HOME="$out/share/" bash install.sh
      sed -i "/ldconfig/d" ./love && rm ./usr/lib/libSDL2-2.0.so.0
      sed -i "s/Exec=.*/Exec=olympus %u/g" ../../share/applications/Olympus.desktop
    '';
  };
in
buildFHSEnv {
  inherit (olympus) name;
  runScript = "${olympus}/opt/olympus/olympus";
  targetPkgs = pkgs: [
    pkgs.freetype
    pkgs.zlib
    pkgs.SDL2
    pkgs.curl
    pkgs.libpulseaudio
    pkgs.gtk3
    pkgs.glib
  ];

  meta.platforms = lib.platforms.linux;
  meta.broken = true;

  # https://github.com/EverestAPI/Olympus/blob/main/lib-linux/olympus.desktop
  # https://stackoverflow.com/questions/8822097/how-to-replace-a-whole-line-with-sed
  extraInstallCommands = ''cp -r "${olympus}/share/" $out'';
}
