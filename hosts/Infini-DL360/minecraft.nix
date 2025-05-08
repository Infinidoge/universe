{ pkgs, ... }:

{
  services.minecraft-servers.servers.hackcraft = {
    enable = true;
    jvmOpts = [
      "-Xmx8G"
      "-Xms8G"

      "-XX:+UseZGC"
      "-XX:+ZGenerational"
      "-XX:+UseNUMA"
      "-javaagent:unsup-1.1-beta1.jar"
    ];
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
