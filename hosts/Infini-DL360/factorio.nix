{ config, private, ... }:

{
  services.factorio = {
    enable = true;
    openFirewall = true;
    loadLatestSave = true;

    stateDir = "/srv/factorio";

    admins = [ "Infinidoge" ];

    game-name = "Hacktorio";
    game-password = private.variables.factorio-password;

    mapGenSettings = {
      seed = "2239686687";
    };
  };
}
