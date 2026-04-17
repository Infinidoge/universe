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

  persist.directories = [
    "/var/lib/private/alloy"
  ];

  services.alloy = {
    enable = true;
    extraFlags = [
      "--server.http.listen-addr=0.0.0.0:10301"
    ];
  };

  # TODO: Switch to public endpoint with authentication?
  # Log aggregation depending on Tailscale feels... suboptimal
  environment.etc."alloy/loki.alloy".text = ''
    loki.write "default" {
      endpoint {
        url = "http://iris.tailnet.inx.moe:10300/loki/api/v1/push"
      }
      external_labels = {}
    }
  '';

  environment.etc."alloy/journal.alloy".text = ''
    discovery.relabel "journal" {
      targets = []

      rule {
        source_labels = ["__journal__systemd_unit"]
        target_label  = "unit"
      }
    }

    loki.source.journal "journal" {
      max_age       = "12h0m0s"
      relabel_rules = discovery.relabel.journal.rules
      forward_to    = [loki.write.default.receiver]
      labels        = {
        host = "${hostName}",
        job  = "system-journal",
      }
    }
  '';
}
