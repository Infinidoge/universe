{ ... }:
let
  uuid = uuid: "/dev/disk/by-uuid/${uuid}";

  esp = uuid "1DB7-2844";
  main = uuid "13f97ece-823e-4785-b06e-6c284105d379";
  backup = uuid "dabfc36b-20d1-4b09-8f55-4f9df7499741";
  hydrus = uuid "2a025f29-4058-4a76-8f38-483f0925375d";

  commonOptions = [
    "autodefrag"
    "noatime"
    "ssd"
  ];
in
{
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=28G"
        "mode=755"
      ];
    };

    "/media/main" = {
      device = main;
      fsType = "btrfs";
      options = commonOptions;
    };

    "/media/backup" = {
      device = backup;
      fsType = "btrfs";
      options = commonOptions;
    };

    "/persist" = {
      device = main;
      fsType = "btrfs";
      options = [ "subvol=root" ] ++ commonOptions;
      neededForBoot = true;
    };

    "/persist/srv" = {
      device = main;
      fsType = "btrfs";
      options = [ "subvol=root/srv" ] ++ commonOptions;
      neededForBoot = true;
    };

    "/etc/ssh" = {
      device = main;
      fsType = "btrfs";
      options = [ "subvolid=262" ] ++ commonOptions;
      neededForBoot = true;
    };

    "/nix" = {
      device = main;
      fsType = "btrfs";
      options = [ "subvol=nix" ] ++ commonOptions;
      neededForBoot = true;
    };

    "/boot" = {
      device = main;
      fsType = "btrfs";
      options = [ "subvol=boot" ] ++ commonOptions;
      neededForBoot = true;
    };

    "/boot/efi" = {
      device = esp;
      fsType = "vfat";
      neededForBoot = true;
    };

    "/home/infinidoge/Hydrus" = {
      device = hydrus;
      fsType = "btrfs";
      options = [ "subvol=Hydrus" ] ++ commonOptions;
    };
  };

  swapDevices = [
    { device = uuid "37916097-dbb9-4a74-b761-17043629642a"; }
  ];
}
