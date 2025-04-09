{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "hexagon";
  version = "unstable-2023-07-24";

  src = fetchFromGitHub {
    owner = "Master-Bw3";
    repo = pname;
    rev = "8a2361b0e3e3deedf4bfda9275390e6c6fc7b335";
    hash = "sha256-hQ5igy9OT+BdYVki/xrIqh12lOboJYPPQmk0BuGqx0o=";
  };

  cargoHash = "sha256-e187AM33Swv3nx97jUUlAn6dLnIFXTCiqm0sCm+9b04=";

  doCheck = false;

  meta = with lib; {
    description = "Hexagon is a programming language for Hex Casting. Hexagon is a superset of the hexpattern format, adding variables, if statements, and more.";
    homepage = "https://github.com/Master-Bw3/Hexagon";
    license = licenses.unfree;
    maintainers = with maintainers; [ infinidoge ];
  };
}
