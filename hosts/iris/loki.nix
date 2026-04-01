{ config, ... }:
{
  persist.directories = [
    {
      directory = config.services.loki.dataDir;
      inherit (config.services.loki) user group;
    }
  ];

  services.loki = {
    enable = true;
    # Config based on https://xeiaso.net/blog/prometheus-grafana-loki-nixos-2020-11-20/
    # https://gist.github.com/Xe/c3c786b41ec2820725ee77a7af551225
    # https://gist.github.com/rickhull/895b0cb38fdd537c1078a858cf15d63e
    configuration = {
      auth_enabled = false;
      server.http_listen_port = 10300;
      ingester = {
        lifecycler = {
          address = "0.0.0.0";
          ring = {
            kvstore.store = "inmemory";
            replication_factor = 1;
          };
          final_sleep = "0s";
        };
        chunk_idle_period = "1h";
        max_chunk_age = "1h";
        chunk_target_size = 1048576;
        chunk_retain_period = "30s";
      };
      compactor = {
        working_directory = "/var/lib/loki/compactor";
        compactor_ring.kvstore.store = "inmemory";
      };
      schema_config.configs = [
        {
          from = "2026-03-24";
          store = "tsdb";
          object_store = "filesystem";
          schema = "v13";
          index = {
            prefix = "index_";
            period = "24h";
          };
        }
      ];
      storage_config = {
        tsdb_shipper = {
          active_index_directory = "/var/lib/loki/tsdb-shipper-active";
          cache_location = "/var/lib/loki/tsdb-shipper-cache";
          cache_ttl = "24h";
        };
        filesystem.directory = "/var/lib/loki/chunks";
      };
      limits_config = {
        reject_old_samples = true;
        reject_old_samples_max_age = "168h";
      };
      table_manager = {
        retention_deletes_enabled = false;
        retention_period = "0s";
      };
    };
  };
}
