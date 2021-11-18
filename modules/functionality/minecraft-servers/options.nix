{ lib, ... }:
with lib;
{
  services.minecraft-servers = {
    enable = mkEnableOption "minecraft servers";
    # TODO: verbose minecraft-servers enable option

    openFirewall =
      mkEnableOption "opening the firewall for each server by default";
    # TODO: verbose outer openFirewall option

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/minecraft";
      # TODO: verbose dataDir option
    };

    servers = mkOption {
      type = types.attrsOf (types.submodule {
        enable = mkEnableOption "this minecraft server";
        # TODO: verbose server enable option

        declarative = mkEnableOption "declarative server management";
        # TODO: verbose declarative option

        eula = mkEnableOption "accepting the eula";
        # TODO: verbose eula option

        openFirewall = mkOption {
          type = types.bool;
          default = true; # cfg.openFirewall;
          # TODO: openFirewall description
        };

        jvmOpts = mkOption {
          type = types.separatedString " ";
          default = "-Xmx2048M -Xms2048M";
          # TODO: verbose jvmOpts option
        };

        package = mkOption {
          type = types.package;
          default = pkgs.minecraft-server;
          # TODO: verbose package option
        };

        whitelist = mkOption {
          type =
            let
              minecraftUUID = types.strMatching
                "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"
              // {
                description = "Minecraft UUID";
              };
            in
            types.attrsOf minecraftUUID;
          default = { };
          # TODO: verbose whitelist option
        };

        serverProperties = mkOption {
          type = with types; attrsOf (oneOf [ bool int str ]);
          default = { server-port = 25565; };
          # TODO: verbose serverProperties option
        };
      });
    };
  };
}
