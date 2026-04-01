{ config, ... }:
let
  nodePort = config.services.prometheus.exporters.node.port;

  # TODO: Declare somewhere in config
  nodes = [
    # "iris" # Covered by localhost

    "apophis"
    "artemis"
    "daedalus"
    "dionysus"
    "hestia"
    "pluto"

    # "infini-router" # TODO: Setup
    # "vulcan" # TODO: Setup
  ];
in
{
  persist.directories = [
    {
      directory = "/var/lib/${config.services.prometheus.stateDir}";
      user = "prometheus";
      group = "prometheus";
    }
  ];

  services.prometheus = {
    enable = true;
    port = 10200;

    scrapeConfigs = [
      {
        job_name = "nodes";
        static_configs = [
          {
            targets = [
              "127.0.0.1:${toString nodePort}"
            ];
          }
        ];
        dns_sd_configs = [
          {
            type = "A";
            port = nodePort;
            names = map (n: n + ".tailnet.inx.moe") nodes;
          }
        ];
      }
    ];
  };
}
