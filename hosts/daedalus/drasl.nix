# I personally bought Minecraft twice
# My friends all own or have owned Minecraft
# But sometimes people don't want to use Mojang/Microsoft's servers
# This is for that
{
  pkgs,
  common,
  config,
  inputs,
  ...
}:
let
  cfg = config.services.drasl;
  domain = common.subdomain "drasl";
in

{
  disabledModules = [ "services/web-apps/drasl.nix" ];
  imports = [ inputs.drasl.nixosModules.drasl ];

  persist.directories = [ "/var/lib/private/drasl" ];

  services.drasl = {
    enable = true;
    settings = {
      Domain = domain;
      BaseURL = "https://${domain}";
      ListenAddress = "127.0.0.1:27585";
      DefaultAdmins = [ "Infinidoge" ];
      InstanceName = "INX Drasl";
      ApplicationOwner = "INX";

      AllowChangingPlayerName = true;
      SignPublicKeys = false;
      DefaultMaxPlayerCount = 3;

      CreateNewPlayer = {
        Allow = true;
        RequireInvite = true;
      };

      RegistrationUsernamePassword = {
        CreateNewPlayer = {
          Allow = true;
          RequireInvite = true;
          AllowChoosingUUID = true;
        };
        ImportExistingPlayer = [
          {
            RequireInvite = true;
            FallbackAPIServerNickname = "Mojang";
          }
        ];
      };

      FallbackAPIServers = [
        {
          Nickname = "Mojang";
          EnableAuthentication = true;
          ForwardSkins = true;
          DiscoveryMinecraftClientURL = "https://discovery.minecraftservices.com/minecraft/client";
          SetSkinURL = "https://www.minecraft.net/msaprofile/mygames/editskin";
          CacheTTLSeconds = 60;
        }
      ];

      ImportExistingPlayer = [
        {
          FallbackAPIServerNickname = "Mojang";
        }
      ];
    };
  };

  services.nginx.virtualHosts.${domain} = common.nginx.ssl-inx // {
    locations."/".proxyPass = "http://${cfg.settings.ListenAddress}";
  };
}
