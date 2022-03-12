{ config, lib, pkgs, ... }:
with lib;
with lib.hlissner;
let
  cfg = config.services.minecraft-servers;
in
{
  options.services.minecraft-servers = {
    enable = mkBoolOpt false;
    eula = mkBoolOpt false;
    openFirewall = mkBoolOpt false;
    dataDir = mkOpt types.path "/srv/minecraft";

    servers = mkOption {
      default = { };
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkBoolOpt false;

          autoStart = mkBoolOpt true;

          openFirewall = mkBoolOpt cfg.openFirewall;

          restart = mkOpt types.str "always";

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
          };

          serverProperties = mkOpt (with types; attrsOf (oneOf [ bool int str ])) { };

          package = mkOpt types.package pkgs.minecraft-server;

          jvmOpts = mkOpt (types.separatedString " ") "-Xmx2G -Xms1G";
        };
      });
    };
  };

  config = mkIf cfg.enable
    (
      let
        servers = filterAttrs (_: cfg: cfg.enable) cfg.servers;
      in
      {
        users.users.minecraft = {
          description = "Minecraft server service user";
          home = cfg.dataDir;
          isSystemUser = true;
          group = "minecraft";
        };
        users.groups.minecraft = { };

        assertions = [
          {
            assertion = cfg.eula;
            message = "You must agree to Mojangs EULA to run minecraft-servers."
              + " Read https://account.mojang.com/documents/minecraft_eula and"
              + " set `services.minecraft-servers.eula` to `true` if you agree.";
          }
        ];

        networking.firewall =
          let
            toOpen = filterAttrs (_: cfg: cfg.openFirewall) servers;
            UDPPorts = mapAttrsToList (name: conf: conf.serverProperties.server-port or 25565) toOpen;
            TCPPorts = concatLists
              (mapAttrsToList
                (name: conf: with conf;
                (optional (serverProperties.enable-rcon or false) (serverProperties."rcon.port" or 25575)) ++
                (optional (serverProperties.enable-query or false) (serverProperties."query.port" or 25565))
                )
                toOpen
              );
          in
          rec {
            allowedUDPPorts = UDPPorts;
            allowedTCPPorts = UDPPorts ++ TCPPorts;
          };

        system.activationScripts.minecraft-server-data-dir.text = ''
          mkdir -p ${cfg.dataDir}
          chown minecraft:minecraft ${cfg.dataDir}
          chmod -R 775 ${cfg.dataDir}
        '';

        systemd.services = mapAttrs'
          (name: conf:
            let
              serverDir = "${cfg.dataDir}/${name}";
              tmux = "${getBin pkgs.tmux}/bin/tmux";
              tmuxSock = "/run/minecraft/${name}.sock";

              startScript = pkgs.writeScript "minecraft-start-${name}" ''
                #!${pkgs.runtimeShell}

                cd ${serverDir}
                ${tmux} -S ${tmuxSock} new -d ${conf.package}/bin/minecraft-server ${conf.jvmOpts}
              '';

              stopScript = pkgs.writeScript "minecraft-stop-${name}" ''
                #!${pkgs.runtimeShell}

                if ! [ -d "/proc/$1" ]; then
                  exit 0
                fi

                ${tmux} -S ${tmuxSock} send-keys stop Enter
              '';
            in
            {
              name = "minecraft-server-${name}";
              value = {
                description = "Minecraft Server ${name}";
                wantedBy = mkIf conf.autoStart [ "multi-user.target" ];
                after = [ "network.target" ];

                enable = conf.enable;

                serviceConfig = {
                  ExecStart = "${startScript}";
                  ExecStop = "${stopScript} $MAINPID";
                  Restart = conf.restart;
                  User = "minecraft";
                  Type = "forking";
                  GuessMainPID = true;
                  RuntimeDirectory = "minecraft";
                };

                preStart =
                  let
                    eula = builtins.toFile "eula.txt" ''
                      # eula.txt managed by NixOS Configuration
                      eula=true
                    '';

                    whitelist = pkgs.writeText "whitelist.json"
                      (builtins.toJSON
                        (mapAttrsToList (n: v: { name = n; uuid = v; }) conf.whitelist));

                    serverProperties =
                      let
                        cfgToString = v: if builtins.isBool v then boolToString v else toString v;
                      in
                      pkgs.writeText "server.properties" (''
                        # server.properties managed by NixOS configuration
                      '' + concatStringsSep "\n" (mapAttrsToList
                        (n: v: "${n}=${cfgToString v}")
                        conf.serverProperties));
                  in
                  ''
                    mkdir -p ${serverDir}
                    chmod -R 775 ${serverDir}
                    cd ${serverDir}
                    ln -sf ${eula} eula.txt
                    ln -sf ${whitelist} whitelist.json
                    cp -f ${serverProperties} server.properties
                  '';

                postStart = ''
                  ${pkgs.coreutils}/bin/chmod 660 ${tmuxSock}
                '';
              };
            })
          servers;
      }
    );
}
