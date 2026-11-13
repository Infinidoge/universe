{ pkgs, ... }:
let
  common = [ "-XX:+UseNUMA" ];

  unsup = [ "-javaagent:${pkgs.unsup}" ];

  drasl = [
    "-Dminecraft.api.env=custom"
    "-Dminecraft.api.auth.host=https://drasl.inx.moe/auth"
    "-Dminecraft.api.account.host=https://drasl.inx.moe/account"
    "-Dminecraft.api.session.host=https://drasl.inx.moe/session"
    "-Dminecraft.api.services.host=https://drasl.inx.moe/services"
  ];

  withVersion = loaderVersion: minecraft: minecraft.override { inherit loaderVersion; };

  inherit (pkgs) minecraftServers;
in
{
  services.minecraft-servers.recommendedJVMArgs = true;

  services.minecraft-servers.servers.hackcraft = {
    enable = true;
    autoStart = false;
    allocatedRAM = "8G";
    jvmArgs = common ++ unsup;
    serverProperties = {
      motd = "Hacking, and perhaps, even crafting!";
      difficulty = "normal";
      allow-flight = true;
      enforce-secure-profile = false;
      server-port = 25675;
      spawn-protection = 0;
    };
    package = pkgs.writeShellApplication {
      name = "mincraft-server";
      runtimeInputs = [ pkgs.minecraftServers.vanilla-1_20_1.java ];
      text = ''
        java "$@" @libraries/net/minecraftforge/forge/1.20.1-47.4.0/unix_args.txt nogui
      '';
      passthru = {
        inherit (pkgs.minecraftServers.vanilla-1_20_1) java recommendedJVMArgs;
      };
    };
  };

  services.minecraft-servers.servers.aquamidoge = {
    enable = true;
    autoStart = false;
    allocatedRAM = "8G";
    jvmArgs = common ++ unsup ++ drasl;
    package = minecraftServers.quilt-1_19_2 |> withVersion "0.28.1";
    serverProperties = {
      motd = "A server with friends and an uncreative name";
      difficulty = "hard";
      allow-flight = true;
      enforce-secure-profile = false;
      server-port = 25676;
      spawn-protection = 0;
    };
  };
}
