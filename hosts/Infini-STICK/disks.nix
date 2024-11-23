{ lib, ... }:
with lib.our.disko;
let
  inherit (lib) genAttrs flip;
in
{
  disko.devices = {
    nodev."/" = mkTmpfs "2G";
    disk.stick = mkDisk "some-usb-stick" {
      partitions = {
        boot = mkESP "64M" "/boot/efi";
        main = mkBtrfsPart "100%" "/media/main" {
          subvolumes = mkBtrfsSubvols {
            "/boot" = { };
            "/etc/ssh" = { };
            "/nix" = { };
            "/persist" = { };
          };
        };
      };
    };
  };

  fileSystems = flip genAttrs (_: { neededForBoot = true; }) [
    "/persist"
    "/etc/ssh"
  ];
}
