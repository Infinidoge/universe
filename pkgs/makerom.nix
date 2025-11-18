{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "makerom";
  version = "0.18.5";

  src = fetchFromGitHub {
    owner = "3DSGuy";
    repo = "Project_CTR";
    rev = "02f2411d1ad5cf65d02302bbe81d89378026eeb2";
    sha256 = "sha256-XQyzi5Ce9h59Aw3rqptKDtQsSfnVbeZR9uhWLOCzGLQ=";
  };

  sourceRoot = "${src.name}/makerom";

  enableParallelBuilding = true;

  preBuild = ''
    make -j $NIX_BUILD_CORES deps
  '';

  # workaround for https://github.com/3DSGuy/Project_CTR/issues/145
  env.NIX_CFLAGS_COMPILE = "-O0";

  installPhase = "
    mkdir $out/bin -p
    cp bin/makerom${stdenv.hostPlatform.extensions.executable} $out/bin/
  ";

  meta = {
    license = lib.licenses.mit;
    description = "A CLI tool to create CTR (Nintendo 3DS) ROM images.";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ infinidoge ];
    mainProgram = "makerom";
  };
}
