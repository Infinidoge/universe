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
}
