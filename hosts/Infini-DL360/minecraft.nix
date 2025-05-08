{ pkgs, ... }:

{
  services.minecraft-servers.servers.hackcraft = {
    enable = true;
    package = pkgs.writeShellApplication {
      name = "mincraft-server";
      runtimeInputs = with pkgs; [ openjdk21 ];
      text = ''
        java @user_jvm_args.txt "$@" @libraries/net/minecraftforge/forge/1.20.1-47.4.0/unix_args.txt nogui
      '';
    };
  };
}
