# I personally bought Minecraft twice
# My friends all own or have owned Minecraft
# But sometimes people don't want to use Mojang/Microsoft's servers
# This is for that
{
  common,
  config,
  ...
}:
let
  cfg = config.services.drasl;
  domain = common.subdomain "drasl";

  Mojang = {
    Nickname = "Mojang";
    SessionURL = "https://sessionserver.mojang.com";
    AccountURL = "https://api.mojang.com";
  };
in

{
  services.drasl = {
    enable = true;
    settings = {
      Domain = domain;
      BaseURL = "https://${domain}";
      ListenAddress = "127.0.0.1:27585";
      DefaultAdmins = [ "Infinidoge" ];
      InstanceName = "INX Drasl";
      ApplicationOwner = "INX";

      AllowAddingDeletingPlayers = true;
      AllowChangingPlayerName = true;
      DefaultMaxPlayerCount = 3;
      CreateNewPlayer.AllowChoosingUUID = true;
      RegistrationNewPlayer = {
        Allow = true;
        RequireInvite = true;
      };
      RegistrationExistingPlayer = {
        Allow = true;
        RequireInvite = true;
      };

      FallbackAPIServers = [
        (
          Mojang
          // {
            ServicesURL = "https://api.minecraftservices.com";
            SkinDomains = [ "textures.minecraft.net" ];
            CacheTTLSeconds = 60;
          }
        )
      ];

      ImportExistingPlayer = Mojang // {
        Allow = true;
        SetSkinURL = "https://www.minecraft.net/msaprofile/mygames/editskin";
      };
    };
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/".proxyPass = "http://${cfg.settings.ListenAddress}";
  };
}
