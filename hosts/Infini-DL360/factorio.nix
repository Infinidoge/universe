{ private, ... }:

{
  services.factorio = {
    enable = true;
    openFirewall = true;
    loadLatestSave = true;

    stateDir = "/srv/factorio";

    admins = [ "Infinidoge" ];

    saveName = "hacktorio_space_age";
    game-name = "Hacktorio 3: Space Age";
    game-password = private.variables.factorio-password;
  };
}
