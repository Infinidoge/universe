{ private, ... }:

{
  services.factorio = {
    enable = true;
    openFirewall = true;
    loadLatestSave = true;

    stateDir = "/srv/factorio";

    admins = [ "Infinidoge" ];

    saveName = "hacktorio_space_age_2";
    game-name = "Hacktorio 4: Space Age 2";
    game-password = private.variables.factorio-password;
  };
}
