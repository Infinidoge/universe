{ config, ... }:
{
  programs.keychain = {
    enable = true;
    extraFlags = [ "--quiet" "--dir ${config.xdg.configHome}/keychain" ];

    keys = [ "id_ed25519" ];
  };
}
