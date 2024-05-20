{ config, pkgs, lib, ... }:
let
  domain = config.common.subdomain "hydra";
in
{
  services.nginx.virtualHosts.${domain} = config.common.nginx.ssl // {
    locations."/" = {
      proxyPass = "http://localhost:${builtins.toString config.services.hydra.port}";
    };
  };

  services.hydra = {
    enable = true;
    port = 3333;
    baseDir = "/srv/hydra";
    hydraURL = "https://${domain}";
    notificationSender = config.common.email.withSubaddress "hydra";
    smtpHost = config.common.email.smtp.address;
    useSubstitutes = true;
    environmentFile = config.secrets.hydra;
    extraEnv = {
      EMAIL_SENDER_TRANSPORT_sasl_username = config.common.email.outgoing;
      EMAIL_SENDER_TRANSPORT_port = builtins.toString config.common.email.smtp.SSLTLS;
      EMAIL_SENDER_TRANSPORT_ssl = "ssl";
    };
    extraConfig = ''
      binary_cache_secret_key_file = ${config.secrets.binary-cache-private-key}
      <git-input>
        timeout = 3600
      </git-input>
    '';
  };

  nix.settings.allowed-uris = [
    "github:"
    "git+https://github.com/"
    "git+ssh://git@github.com/"

    "git+https://git.inx.moe/"
    "git+ssh://git@inx.moe/"

    "gitlab:"
    "git+https://gitlab.com/"
    "git+ssh://git@gitlab.com/"

    "sourcehut:"
    "git+https://git.sr.ht/"
    "git+ssh://git@git.sr.ht/"
  ];

  nix.buildMachines = [
    {
      hostName = "localhost";
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
      protocol = "ssh";
      maxJobs = 32;
      speedFactor = 16;
    }
  ];
}
