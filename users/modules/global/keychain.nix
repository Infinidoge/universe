{ config, ... }:
{
  services.ssh-agent.enable = true;

  programs.keychain = {
    enable = true;
    inheritType = "any";
    extraFlags = [ "--quiet" "--dir ${config.xdg.configHome}/keychain" ];
    keys = [ "id_ed25519" ];
  };
}
