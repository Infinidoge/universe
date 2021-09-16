{ lib, ... }: {
  boot.loader = {
    grub = {
      enable = lib.mkDefault true;
      device = "/dev/disk/by-uuid/6836-6848";
      efiSupport = true;
      useOSProber = true;
      extraEntries = ''
        menuentry 'Arch Linux' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'gnu    linux-simple-06791df5-a482-4c10-af2b-038d74212c1b' {
                load_video
                set gfxpayload=keep
                insmod gzio
                insmod part_gpt
                insmod ext2
                if [ x$feature_platform_search_hint = xy ]; then
                  search --no-floppy --fs-uuid --set=root  06791df5-a482-4c10-af2b-038d74212c1b
                else
                  search --no-floppy --fs-uuid --set=root 06791df5-a482-4c10-af2b-038d74212c1b
                fi
                echo    'Loading Linux linux ...'
                linux   /boot/vmlinuz-linux root=UUID=06791df5-a482-4c10-af2b-038d74212c1b rw acpi_sleep=nonvs     loglevel=3 resume=8d0f13e7-135e-4dfd-9090-fabf1fc406c2
                echo    'Loading initial ramdisk ...'
                initrd  /boot/amd-ucode.img /boot/initramfs-linux.img
        }
        submenu 'Advanced options for Arch Linux' $menuentry_id_option 'gnulinux-advanced-06791df5-a482-4c10-a    f2b-038d74212c1b' {
                menuentry 'Arch Linux, with Linux linux' --class arch --class gnu-linux --class gnu --class os     $menuentry_id_option 'gnulinux-linux-advanced-06791df5-a482-4c10-af2b-038d74212c1b' {
                        load_video
                        set gfxpayload=keep
                        insmod gzio
                        insmod part_gpt
                        insmod ext2
                        if [ x$feature_platform_search_hint = xy ]; then
                          search --no-floppy --fs-uuid --set=root  06791df5-a482-4c10-af2b-038d74212c1b
                        else
                          search --no-floppy --fs-uuid --set=root 06791df5-a482-4c10-af2b-038d74212c1b
                        fi
                        echo    'Loading Linux linux ...'
                        linux   /boot/vmlinuz-linux root=UUID=06791df5-a482-4c10-af2b-038d74212c1b rw acpi_sle    ep=nonvs loglevel=3 resume=8d0f13e7-135e-4dfd-9090-fabf1fc406c2
                        echo    'Loading initial ramdisk ...'
                        initrd  /boot/amd-ucode.img /boot/initramfs-linux.img
                }
                menuentry 'Arch Linux, with Linux linux (fallback initramfs)' --class arch --class gnu-linux -    -class gnu --class os $menuentry_id_option 'gnulinux-linux-fallback-06791df5-a482-4c10-af2b-038d74212c    1b' {
                        load_video
                        set gfxpayload=keep
                        insmod gzio
                        insmod part_gpt
                        insmod ext2
                        if [ x$feature_platform_search_hint = xy ]; then
                          search --no-floppy --fs-uuid --set=root  06791df5-a482-4c10-af2b-038d74212c1b
                        else
                          search --no-floppy --fs-uuid --set=root 06791df5-a482-4c10-af2b-038d74212c1b
                        fi
                        echo    'Loading Linux linux ...'
                        linux   /boot/vmlinuz-linux root=UUID=06791df5-a482-4c10-af2b-038d74212c1b rw acpi_sle    ep=nonvs loglevel=3 resume=8d0f13e7-135e-4dfd-9090-fabf1fc406c2
                        echo    'Loading initial ramdisk ...'
                        initrd  /boot/initramfs-linux-fallback.img
                }
        }

        menuentry 'Windows Boot Manager' --class windows --class os $menuentry_id_option '    osprober-efi-6836-6848' {
                insmod part_gpt
                insmod fat
                if [ x$feature_platform_search_hint = xy ]; then
                  search --no-floppy --fs-uuid --set=root  6836-6848
                else
                  search --no-floppy --fs-uuid --set=root 6836-6848
                fi
                chainloader /EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
    efi = {
      canTouchEfiVariables = true;
    };
  };
}
