{ config, lib, pkgs, ... }@main:

with lib;

let
  cfg = config.services.minecraft-servers;


in
{
  options = (import ./options.nix) main;

  config = mkIf cfg.enable {
    users.users.minecraft = {
      description = "Minecraft server service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "minecraft";
    };

    users.groups.minecraft = { };

    # systemd.services = mkIf (cfg.enable && cfg.servers != { }) ((import ./service.nix) main cfg);

  };

  # networking.firewall = let

  #   propertyFunc = attrsets.mapAttrsToList (name: value:
  #     let props = value.serverProperties;
  #     in (if value.declarative then [
  #       (props.server-port or 25565)
  #       (if props.enable-rcon or false then
  #         props."rcon.port" or 25575
  #       else
  #         null)
  #       (if props.enable-query or false then
  #         props "query.port" or 25565
  #       else
  #         null)
  #     ] else
  #       null)) cfg.servers;

  #   openedPorts = lists.flatten [ serverPorts queryPorts rconPorts ];
  # in {
  #   allowedUDPPorts = openedPorts;
  #   allowedTCPPorts = openedPorts;
  # };

  # assertions = [{
  #   assertion = all (i: i.eula == true) (attrValues cfg.servers);
  #   message = "You must agree to Mojangs EULA to run minecraft-server."
  #     + " Read https://account.mojang.com/documents/minecraft_eula and"
  #     + " set `services.minecraft-servers.servers.<name>.eula` to `true` for all servers if you agree.";
  # }];
}
