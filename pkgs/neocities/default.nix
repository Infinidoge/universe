{ lib
, bundlerApp
}:
bundlerApp {
  pname = "neocities";
  gemdir = ./.;
  exes = [ "neocities" ];

  meta = with lib; {
    mainProgram = "neocities";
  };
}
