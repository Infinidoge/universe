# Infinidoge's Universe

### An Essay on the Overengineering of Dotfiles

## Notes

This repository is not a general purpose configuration.
It is tailored specifically to my uses, and while you may find inspiration from it, do not expect it to be your productivity silver bullet.
Additionally, I WILL FORCE PUSH TO THIS REPOSITORY WITHOUT NOTICE.

## Structure

### `flake.nix`

The root of everything, the place where it all comes together.
This configuration was originally based on the DevOS template, but I have since rewritten it to use flake-parts instead!
Some parts of Digga's library is replicated in [lib/digga.nix](./lib/digga.nix) as a stop-gap measure until I rewrite it to use something else.

### `/hosts`

Each of the devices that my configuration is setup to target.
Each host is a directory under `/hosts`, with the `default.nix` file defining the host.
In each of the hosts that I particularly care for is a `readme.org` file containing source blocks.
These source blocks are tangled to the respective bash scripts, which are used for provisioning a device with that configuration.

Summary of what the scripts do

- `prep.bash /path/to/dev/disk`: Partitions and formats the given disk.
- `install.bash /path/to/dev/disk`: Mounts the file systems, then runs all commands for an installation, including cloning the configuration into `/etc/nixos` and installing Doom Emacs to `.config/emacs`
- `bare_install.bash`: Just runs `nixos-install`
- `mount.bash /path/to/dev/disk`: Mounts the file systems as in `install.bash`.
- `data_setup.bash /path/to/dev/disk`: Partitions the disk as a separate data storage; Used for Infini-SERVER.

### `/lib`

Nix library components.

### `/modules`

The real meat of the configuration, defines a bunch of NixOS modules that all get recursively imported;

#### `/modules/functionality`

Modules that create some sort of new functionality.

- `ensure.nix`: Takes a list of directories, and ensures they exist after boot.
- `soft-serve.nix`: Runs the `soft-serve` git server.
- `ssh-tunnel.nix`: Runs an SSH session for opening ports.

#### `/modules/global`

Definitions that apply globally across all devices.

- Each file in the `caches` folder is a definition for a binary cache.
- `general.nix`: Broad general things that apply globally.
- `hm-system-defaults.nix` defines default home-manager configurations that apply to all users
- `networking.nix`: Networking related settings, such as setting up tailscale, avahi, and DNS.
- `nix.nix` defines Nix settings, like allowed users, garbage collection, etc. Also installs some Nix-related packages
- `options.nix` defines shortcut options used throughout the configuration.
- `packages.nix`: Packages that should be installed on everything.
- `security.nix`: Various security related settings.
- `shell.nix`: Shell-related settings like aliases.
- `programming`: Packages/configuration for various programming languages.
  - `haskell.nix`
  - `java.nix`
  - `kotlin.nix`
  - `lua.nix`
  - `nim.nix`
  - `python.nix`
  - `racket.nix`
  - `rust.nix`
  - `zig.nix`

#### `/modules/modules`

Modules that simplify the setup of things between devices.
Differs from `global` in that they are gated behind options rather than applying globally.

- `boot.nix`: Defines bootloader setups. Ensures that at least 1 of GRUB or systemd boot is selected
- `locale.nix`: Sets up various locale-related things like keymap, compose key, timezone, etc.
- `virtualization.nix`: Sets up things required for virtualization, namely libvirtd and docker.
- `desktop`: Things related to the desktop experience
  - `gaming.nix`: Sets up gaming related software
  - `wm.nix`: Sets up my window manager of choice: Qtile
- `hardware`: Modules that setup hardware
  - `audio.nix`: Sets up audio by enabling sound and enabling pipewire and related software.
  - `form.nix`: Settings that are form-specific. Forms are desktop, laptop, portable, raspberry pi, and server.
  - `gpu.nix`: GPU-specific settings, primarily with regards to setting up drivers and installing software necessary for hardware acceleration.
  - `wireless.nix`: Sets up wireless communication, namely WiFi and Bluetooth.
  - `peripherals`: Modules that setup peripherals like mice or printers.
    - `fprint-sensor.nix`: Sets up a finger print sensor.
    - `printing.nix`: Sets up printing with the printing service.
    - `razer.nix`: Sets up razer products via openrazer.
- `services`: Sets up services.
  - `apcupsd.nix`: Sets up apcupsd to manage my UPS.
  - `foldingathome.nix`: Sets up the Folding@Home service.
  - `nix-ssh-serve.nix`: Sets up Nix ssh serve for serving the Nix store over SSH.
  - `proxy.nix`: Sets up a local Privoxy instance that routes through an SSH SOCKS5 tunnel.
- `software`: Sets up software things
  - `console.nix`: Sets up the console, primarily using `kmscon`.
  - `minipro.nix`: Sets up the minipro tool for using MiniPro brand EEPROM writers. This module has been upstreamed to Nixpkgs, pending merge.
  - `steam.nix`: Sets up Steam, with extra libraries or hacks for getting things running smoothly.

### `/overlays`

Overlays onto the main package set.

- `overrides.nix`: The overlay used for pinning packages to different versions, generally different 'channels' of Nixpkgs.
- `patches`: An overlay for patching software. Currently patches `coreutils` for a joke.

### `/pkgs`

Packages that I've packaged for myself for one reason or another.
Some may be upstreamed in the future, however some don't generally belong in Nixpkgs.

- `default.nix`: Flake module that takes the packages from `all-packages.nix` and outputs them into `packages`/`legacyPackages`. Additionally, it creates an overlay called `packages` containing all of the packages.
- `all-packages.nix`: Collects the packages and applies `callPackage`.
- `patches`: Any patches necessary for packages go here. Doesn't necessarily exist.

Packages themselves:

- `hexagon.nix`: A runner/compiler for Hex Casting spells.
- `mcaselector.nix`: A wrapper around the MCASelector jar so it runs on Nix.
- `nix-modrinth-prefetch.nix`: A prefetcher for Modrinth mods.
- `olympus.nix`: The olympus mod manager/installer for Celeste
- `setris.nix`: Tetris with Sand!
- `sim65.nix`: The Sim65 65c02 simulator and debugger. Not well tested.
- `substitute-subset.nix`: `substituteAll` for a limited subset of files.
- `unbted.nix`: An NBT editor for Minecraft.

### `/secrets`

Contains and handles all secrets for the configuration.
Managed using `agenix`.

### `/shell`

Things related to the shell environment for this configuration.
This is pending a redo, since I recently replaced `bud` with [my own CLI tool, `universe-cli`](https://github.com/Infinidoge/universe-cli).

### `/users`

The real meat behind my personal configuration. Defines users of the system, including me.

#### `/users/modules`

Mirrors `/modules` in that it defines modules for use with home-manager.

- `bindmounts.nix`: A home-manager module modified from `impermanence`'s home manager module to setup bind mounts.

#### `/users/profiles`

Mirrors `/profiles`.
Should really be refactored since broadly, all of the things here will be universally included.
Most of the modules are self-explanatory from their names.

- `direnv.nix`
- `emacs.nix`
- `flameshot.nix`
- `git.nix`
- `gpg.nix`
- `htop.nix`
- `keychain.nix`
- `kitty.nix`
- `nnn.nix`
- `pass.nix`
- `rofi.nix`
- `ssh.nix`
- `starship.nix`
- `stretchly.nix`
- `theming.nix`
- `tmux.nix`
- `vim.nix`
- `xdg.nix`
- `shells`: Per-shell settings
  - `all.nix`: Imports all other shells
  - `common.nix`: Common things for all shells, imported by each shell
  - `bash.nix`
  - `fish.nix`
  - `ion.nix`
  - `nushell.nix`
  - `zsh.nix`

#### `/users/root`

The root user on all of my devices.
Setup is sparse, pretty much just sets the password, authorized keys, and imports some of the common setup stuff so the root user doesn't differ too much from my main user if I need to be in root for a while.
`ssh-keys.nix` defines the SSH keys accepted for the root user.

#### `/users/infinidoge`

That's me!

My setup is pretty extensive, but reading it isn't too particularly difficult.

- `default.nix`: The main part, installs some packages I want, sets up my SSH keys, pulls in the dotfiles that aren't written in Nix, etc.
- `ssh-keys.nix`: My SSH public keys.
- `config`: The parts of my dotfiles that I can't write in Nix. Mainly uses home manager to put files in the right place
  - `default.nix`: Pulls in the configuration files and puts them where they belong. Also defines my neofetch output.
  - `doom`: My Doom Emacs configuration. Doom Emacs is my editor and home, and I use it extensively.
  - `qtile`: My Qtile configuration. Qtile is my home of homes, the environment I am pretty literally always in while on my computers.
  - `bluegon`: Changes screen color temperature for the benefit of my eyes. Pretty sure my setup is currently broken.
  - `stretchly.json`: Configuration for stretchly, which is supposed to remind me to stretch. Not currently in use
