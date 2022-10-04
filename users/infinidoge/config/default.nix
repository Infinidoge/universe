{ config, main, lib, pkgs, ... }:
with lib;
{
  xdg.configFile = {
    "doom" = {
      source = ./doom;
      onChange = ''
        echo "[doom] applying doom configuration"
        ${config.xdg.configHome}/emacs/bin/doom sync -p
      '';
    };

    "neofetch/config.conf".text =
      let
        image = pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/TheDarkBug/uwufetch/main/res/nixos.png";
          sha256 = "007q947q2a5c8z9r6cc6mj3idq0ss9zsi9xvij8l8chkjnh8fwn2";
        };
      in
      ''
        print_info() {
            info title
            info underline

            info "$(color 7)OS" distro
            info "$(color 15)├─$(color 6) Kernel" kernel
            info "$(color 15)├─$(color 6) Uptime" uptime
            info "$(color 15)└─$(color 6) Packages" packages

            prin
            prin "$(color 7)PC" "${if main.info.model != "" then main.info.model else "A Computer"}"
            info "$(color 15)├─$(color 6) CPU" cpu
            info "$(color 15)├─$(color 6) GPU" gpu
            info "$(color 15)├─$(color 6) Battery" battery
            info "$(color 15)├─$(color 6) Resolution" resolution
            info "$(color 15)└─$(color 6) Memory" memory

            ${ if main.info.graphical then ''
            prin
            prin "$(color 15)WM" ${main.info.env.wm}
            '' else "" }

            prin
            info "$(color 15)Terminal" term
            info "$(color 15)└─$(color 6) Shell" shell

            prin
            prin "$(color 15)Disks"
            info disk

            info cols
        }

        kernel_shorthand="off"
        uptime_shorthand="off"
        memory_percent="on"
        memory_unit="gib"
        separator=" ➜"
        color_blocks="off"

        # Disk
        disk_show=('/' '/media/main' '/media/data')

        # Image
        image_backend="kitty"
        image_source="${image}"
        crop_mode="none"
        image_size="470px"
      '';
  } // optionalAttrs main.info.graphical {
    "qtile".source = ./qtile;

    "blugon".source = ./blugon;
  };
}
