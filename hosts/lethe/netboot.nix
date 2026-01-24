{
  pkgs,
  lib,
  config,
  ...
}:
{
  system.build.netboot = pkgs.symlinkJoin {
    name = "netboot";
    paths = with config.system.build; [
      netbootRamdisk
      kernel
      (pkgs.runCommand "kernel-params" { } ''
        mkdir -p $out
        ln -s "${config.system.build.toplevel}/kernel-params" $out/kernel-params
        ln -s "${config.system.build.toplevel}/init" $out/init
      '')
    ];
    preferLocalBuild = true;
  };
  systemd.network.networks."10-uplink" = {
    matchConfig.Type = "ether";
    networkConfig = {
      DHCP = "yes";
      EmitLLDP = "yes";
      IPv6AcceptRA = "yes";
      MulticastDNS = "yes";
      LinkLocalAddressing = "yes";
      LLDP = "yes";
    };

    dhcpV4Config = {
      UseHostname = false;
      ClientIdentifier = "mac";
    };
  };
}
