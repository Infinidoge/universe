{ config, ... }:
{
  services.ssh-agent.enable = true;

  programs.keychain = {
    enable = true;
    inheritType = "any";
    extraFlags = [ "--quiet" "--quick" "--systemd" "--dir ${config.xdg.configHome}/keychain" "--agents \"\"" ];
    keys = [ "id_ed25519" ];
  };
}
