{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  system.stateVersion = "23.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8oViHNz64NG51uyll/q/hrSGwoHRgvYI3luD/IWTUT root@Infini-SD";

  networking.hostId = "3275c7d3";

  modules.hardware.form.server = true;

  boot.kernelPackages = pkgs.linuxPackages;

  hardware.infiniband.enable = true;

  networking = {
    interfaces.eno4 = {
      ipv4.addresses = [
        {
          address = "128.210.6.109";
          prefixLength = 28;
        }
      ];
    };
    defaultGateway = {
      address = "128.210.6.97";
      interface = "eno4";
    };
  };

  systemd.services.setup-infiniband = {
    wantedBy = [ "network.target" ];
    script = ''
      echo "eth" > /sys/bus/pci/devices/0000:04:00.0/mlx4_port1
      echo "eth" > /sys/bus/pci/devices/0000:04:00.0/mlx4_port2
    '';
  };
}
