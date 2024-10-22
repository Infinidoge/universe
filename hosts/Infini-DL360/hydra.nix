{ config, common, ... }:
let
  domain = common.subdomain "hydra";
in
{
  services.nginx.virtualHosts.${domain} = common.nginx.ssl // {
    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.hydra.port}";
    };
  };

  services.hydra = {
    enable = true;
    port = 3333;
    baseDir = "/srv/hydra";
    hydraURL = "https://${domain}";
    notificationSender = common.email.withSubaddress "hydra";
    smtpHost = common.email.smtp.address;
    useSubstitutes = true;
    environmentFile = config.secrets.hydra;
    extraEnv = {
      EMAIL_SENDER_TRANSPORT_sasl_username = common.email.outgoing;
      EMAIL_SENDER_TRANSPORT_port = toString common.email.smtp.SSLTLS;
      EMAIL_SENDER_TRANSPORT_ssl = "ssl";
    };
    extraConfig = ''
      binary_cache_secret_key_file = ${config.secrets.binary-cache-private-key}
      allow_import_from_derivation = true
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

    "https://git.lix.systems/"
    "git+https://git.lix.systems/"
    "git+ssh://git@git.lix.systems/"
  ];

  nix.buildMachines = [
    {
      hostName = "localhost";
      system = "x86_64-linux";
      supportedFeatures = [ "kvm" "nixos-test" "big-parallel" "benchmark" ];
      protocol = null;
      maxJobs = 32;
      speedFactor = 16;
    }
  ];
}
