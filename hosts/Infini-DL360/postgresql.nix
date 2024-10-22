{ config, pkgs, ... }:
let
  cfg = config.services.postgresql;
  directory = "/srv/postgresql";
in
{
  persist.directories = [{ inherit directory; user = "postgres"; group = "postgres"; }];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "${directory}/${cfg.package.psqlSchema}";
  };
}
