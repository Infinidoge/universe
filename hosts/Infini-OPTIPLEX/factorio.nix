{ config, private, ... }:

{
  persist.directories = [ "/var/lib/factorio" ];

  services.factorio = {
    enable = true;
    openFirewall = true;
    loadLatestSave = true;

    admins = [ "Infinidoge" ];

    game-name = "Hacktorio";
    game-password = private.variables.factorio-password;
  };
}
