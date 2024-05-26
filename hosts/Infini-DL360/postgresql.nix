{ pkgs, config, lib, ... }:
let
  directory = "/srv/postgresql";
in
{
  persist.directories = [{ inherit directory; user = "postgres"; group = "postgresl"; }];

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "${directory}/${config.services.postgresql.package.psqlSchema}";
  };
}
