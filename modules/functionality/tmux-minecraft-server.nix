# Derived from nixpkgs/nixos/modules/services/games/minecraft-server.nix
{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.services.tmux-minecraft-server;

  files = {
    # We don't allow eula=false anyways
    eula = builtins.toFile "eula.txt" ''
      # eula.txt managed by NixOS Configuration
      eula=true
    '';

    whitelist = pkgs.writeText "whitelist.json"
      (builtins.toJSON
        (mapAttrsToList (n: v: { name = n; uuid = v; }) cfg.whitelist));


    serverProperties =
      let
        cfgToString = v: if builtins.isBool v then boolToString v else toString v;
      in
      pkgs.writeText "server.properties" (''
        # server.properties managed by NixOS configuration
      '' + concatStringsSep "\n" (mapAttrsToList
        (n: v: "${n}=${cfgToString v}")
        cfg.serverProperties));
  };

  ports = {
    server = cfg.serverProperties.server-port or 25565;

    rcon =
      if cfg.serverProperties.enable-rcon or false
      then cfg.serverProperties."rcon.port" or 25575
      else null;

    query =
      if cfg.serverProperties.enable-query or false
      then cfg.serverProperties."query.port" or 25565
      else null;
  };
in
{
  options.services.tmux-minecraft-server = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, start a Minecraft Server. The server
        data will be loaded from and saved to
        <option>services.minecraft-server.dataDir</option>.
      '';
    };

    eula = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether you agree to
        <link xlink:href="https://account.mojang.com/documents/minecraft_eula">
        Mojangs EULA</link>. This option must be set to
        <literal>true</literal> to run Minecraft server.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/minecraft";
      description = ''
        Directory to store Minecraft database and other state/data files.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open ports in the firewall for the server.
      '';
    };

    whitelist = mkOption {
      type =
        let
          minecraftUUID = types.strMatching
            "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}" // {
            description = "Minecraft UUID";
          };
        in
        types.attrsOf minecraftUUID;
      default = { };
      description = ''
        Whitelisted players, only has an effect when
        <option>services.minecraft-server.declarative</option> is
        <literal>true</literal> and the whitelist is enabled
        via <option>services.minecraft-server.serverProperties</option> by
        setting <literal>white-list</literal> to <literal>true</literal>.
        This is a mapping from Minecraft usernames to UUIDs.
        You can use <link xlink:href="https://mcuuid.net/"/> to get a
        Minecraft UUID for a username.
      '';
      example = literalExpression ''
        {
          username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
          username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
        };
      '';
    };

    serverProperties = mkOption {
      type = with types; attrsOf (oneOf [ bool int str ]);
      default = { };
      example = literalExpression ''
        {
          server-port = 43000;
          difficulty = 3;
          gamemode = 1;
          max-players = 5;
          motd = "NixOS Minecraft server!";
          white-list = true;
          enable-rcon = true;
          "rcon.password" = "hunter2";
        }
      '';
      description = ''
        Minecraft server properties for the server.properties file. Only has
        an effect when <option>services.minecraft-server.declarative</option>
        is set to <literal>true</literal>. See
        <link xlink:href="https://minecraft.gamepedia.com/Server.properties#Java_Edition_3"/>
        for documentation on these values.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.minecraft-server;
      defaultText = literalExpression "pkgs.minecraft-server";
      example = literalExpression "pkgs.minecraft-server_1_12_2";
      description = "Version of minecraft-server to run.";
    };

    jvmOpts = mkOption {
      type = types.separatedString " ";
      default = "-Xmx2048M -Xms2048M";
      # Example options from https://minecraft.gamepedia.com/Tutorials/Server_startup_script
      example = "-Xmx2048M -Xms4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing "
        + "-XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 "
        + "-XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
      description = "JVM options for the Minecraft server.";
    };
  };

  config = mkIf cfg.enable {
    users.users.minecraft = {
      description = "Minecraft server service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "minecraft";
    };
    users.groups.minecraft = { };

    systemd.services.minecraft-server = {
      description = "Minecraft Server Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/minecraft-server ${cfg.jvmOpts}";
        Restart = "always";
        User = "minecraft";
        WorkingDirectory = cfg.dataDir;
      };

      preStart = with files; ''
        ln -sf ${eula} eula.txt
        ln -sf ${whitelist} whitelist.json
        cp -f ${serverProperties} server.properties
      '';
    };

    networking.firewall = mkIf cfg.openFirewall (with ports; {
      allowedUDPPorts = [ server ];
      allowedTCPPorts = [ server ]
        ++ optional (query != null) query
        ++ optional (rcon != null) rcon;
    });

    assertions = [
      {
        assertion = cfg.eula;
        message = "You must agree to Mojangs EULA to run minecraft-server."
          + " Read https://account.mojang.com/documents/minecraft_eula and"
          + " set `services.minecraft-server.eula` to `true` if you agree.";
      }
    ];
  };
}
