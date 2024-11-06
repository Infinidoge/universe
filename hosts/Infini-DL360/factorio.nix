{ private, ... }:

{
  services.factorio = {
    enable = true;
    openFirewall = true;
    loadLatestSave = true;

    stateDir = "/srv/factorio";

    admins = [ "Infinidoge" ];

    saveName = "hacktorio2";
    game-name = "Hacktorio 2";
    game-password = private.variables.factorio-password;

    mapGenSettings = {
      seed = "3940972377";
    };
  };
}
