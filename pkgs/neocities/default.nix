{ lib
, bundlerApp
}:
bundlerApp {
  pname = "neocities";
  gemdir = ./.;
  exes = [ "neocities" ];

  meta = with lib; {
    description = "The Neocities CLI, written in Ruby";
    homepage = "https://github.com/neocities/neocities-ruby";
    license = licenses.mit;
    maintainers = with maintainers; [ infinidoge ];
    mainProgram = "neocities";
  };
}
