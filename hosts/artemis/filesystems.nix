{ lib, ... }:
with lib.our.filesystems;
let
  main = mkBtrfs "a44af0ff-5667-465d-b80a-1934d1aab8d9";
in
{
  fileSystems = {
    "/" = mkTmpfs "root" "16G";
    "/boot/efi" = mkEFI "3FC9-0182";

    "/media/main" = main [ ];

    "/persist" = neededForBoot main [ "subvol=root" ];
    "/etc/ssh" = neededForBoot main [ "subvolid=628" ];
    "/nix" = neededForBoot main [ "subvol=nix" ];
    "/boot" = neededForBoot main [ "subvol=boot" ];
    "/swap" = neededForBoot main [ "subvol=swap" ];
  };

  swapDevices = [
    {
      device = "/swap/swapfile";
      size = 40 * 1024;
      priority = 2;
    }
  ];
}
