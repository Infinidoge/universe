{
  persist.directories = [ "/var/db" ];

  networking.firewall.allowedTCPPorts = [ 27017 ];

  services.mongodb = {
    enable = true;
    bind_ip = "0.0.0.0";
    enableAuth = true;
    initialRootPasswordFile = "/etc/secrets/mongodb_initial_root_password";
  };
}
