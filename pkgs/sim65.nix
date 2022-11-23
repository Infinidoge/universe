{ stdenv
, fetchFromGitHub
, lib
, wxGTK32
}:

stdenv.mkDerivation {
  name = "sim65";

  src = fetchFromGitHub {
    owner = "sittner";
    repo = "sim65";
    rev = "8557843c93e46e347f6f9d788faef8f302ead560";
    sha256 = "sha256-n+THZuD77gtZ5nMcdaq4Xup95NjVPFiMk0zsTOGiXzc=";
  };

  buildInputs = [ wxGTK32 ];

  installPhase = ''
    mkdir -p $out/bin
    cp sim65 $out/bin
  '';

  meta = with lib; {
    description = "Sim65 is a 65c02 simulator and debugger for Linux/GTK systems";
    longDescription = ''
      Sim65 is a 65c02 simulator and debugger for Linux/GTK systems.
      You can load binary images or S-record files containing 65c02 code and execute it.
      Sim65 allows you to see and alter registers and memory, set breakpoints, single step, and a few other things.
      The program is immature: there are no peripherals, for example, but it suffices for simple simulation purposes.
    '';
    homepage = "http://www.wsxyz.net/sim65/";
    license = licenses.free;
    maintainers = with maintainers; [ infinidoge ];
  };
}
