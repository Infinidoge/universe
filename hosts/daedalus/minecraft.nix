{ pkgs, ... }:
let
  ram = amount: [
    "-Xmx${amount}"
    "-Xms${amount}"
  ];
  common = [ "-XX:+UseNUMA" ];
  java8 = common ++ [ "-XX:UseG1GC" ];
  java17 = common ++ [ "-XX:+UseZGC" ];
  java21 = java17 ++ [ "-XX:+ZGenerational" ];

  unsup = [ "-javaagent:${pkgs.unsup}" ];

  drasl = [
    "-Dminecraft.api.env=custom"
    "-Dminecraft.api.auth.host=https://drasl.inx.moe/auth"
    "-Dminecraft.api.account.host=https://drasl.inx.moe/account"
    "-Dminecraft.api.session.host=https://drasl.inx.moe/session"
    "-Dminecraft.api.services.host=https://drasl.inx.moe/services"
  ];

  withJava21 = minecraft: minecraft.override { jre_headless = pkgs.openjdk21; };
  withVersion = loaderVersion: minecraft: minecraft.override { inherit loaderVersion; };

  inherit (pkgs) minecraftServers;
in
{
  services.minecraft-servers.servers.hackcraft = {
    enable = true;
    jvmOpts = java21 ++ (ram "8G") ++ unsup;
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
      runtimeInputs = with pkgs; [ openjdk21 ];
      text = ''
        java "$@" @libraries/net/minecraftforge/forge/1.20.1-47.4.0/unix_args.txt nogui
      '';
    };
  };

  services.minecraft-servers.servers.aquamidoge = {
    enable = true;
    autoStart = false;
    jvmOpts = java21 ++ (ram "8G") ++ unsup ++ drasl;
    package = minecraftServers.quilt-1_19_2 |> withJava21 |> withVersion "0.28.1";
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
