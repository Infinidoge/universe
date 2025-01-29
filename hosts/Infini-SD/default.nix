{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  networking.hostId = "3275c7d3";

  boot.kernelPackages = pkgs.linuxPackages;

  hardware.infiniband = {
    enable = true;
  };

  modules = {
    hardware = {
      form.server = true;
    };
  };

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

  persist = {
    directories = [
    ];

    files = [
    ];
  };

  system.stateVersion = "23.11";
}
