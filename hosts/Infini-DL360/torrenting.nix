{ pkgs, private, config, lib, ... }:

{
  containers.torrenting = {
    autoStart = true;
    enableTun = true;
    ephemeral = true;
    privateNetwork = true;
    hostAddress = "192.168.1.1";
    localAddress = "192.169.1.2";

    forwardPorts = [
      { hostPort = 9091; }
    ];

    bindMounts = {
      ${config.secrets.ovpn} = { };
    };

    config = {
      system.stateVersion = "25.05";
      nixpkgs.pkgs = pkgs; # Reuse system nixpkgs

      networking.useHostResolvConf = lib.mkForce false;
      services.resolved.enable = true;

      services.openvpn.servers.openvpn = {
        config = ''
          config ${private.files.ovpn}
          auth-user-pass ${config.secrets.ovpn}
        '';
      };

      systemd.services.transmission.serviceConfig = {
        RootDirectoryStartOnly = lib.mkForce false;
        RootDirectory = lib.mkForce "";
      };

      services.transmission = {
        enable = true;
        openRPCPort = true;
        openPeerPorts = true;
        settings = {
          rpc-bind-address = "0.0.0.0";
          rpc-whitelist-enabled = false;
        };
      };
    };
  };
}
