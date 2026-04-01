{ config, ... }:
let
  inherit (config.networking) hostName;
in
{
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" ];
    port = 21650;
  };

  services.promtail = {
    enable = true;
    configuration = {
      server = {
        http_listen_port = 10301;
        grpc_listen_port = 0;
      };
      positions = {
        filename = "/tmp/positions.yaml";
      };
      clients = [
        {
          # TODO: Switch to public endpoint with authentication?
          # Log aggregation depending on Tailscale feels... suboptimal
          url = "http://iris.tailnet.inx.moe:10300/loki/api/v1/push";
        }
      ];
      scrape_configs = [
        {
          job_name = "journal";
          journal = {
            max_age = "12h";
            labels = {
              job = "system-journal";
              host = hostName;
            };
          };
          relabel_configs = [
            {
              source_labels = [ "__journal__systemd_unit" ];
              target_label = "unit";
            }
          ];
        }
      ];
    };
  };
}
