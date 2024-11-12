# Infinidoge's Universe

### An Essay on the Overengineering of Dotfiles

## Notes

This repository is not a general purpose configuration.
It is tailored specifically to my uses, and while you may find inspiration from it, do not expect it to be your productivity silver bullet.
Additionally, I WILL FORCE PUSH TO THIS REPOSITORY WITHOUT NOTICE.

This readme is not actively kept up to date with every single change, so take the exact wording with a grain of salt, and you may need to double check the directories.

## Structure

### `flake.nix`

The root of everything, the place where it all comes together.
This configuration was originally based on the DevOS template, but I have since rewritten it to use flake-parts instead!
Some parts of Digga's library is replicated in [lib/digga.nix](./lib/digga.nix) as a stop-gap measure until I rewrite it to use something else.

### `/bin`

Miscellaneous scripts that I use elsewhere as part of my configuration.

- `bwrap.bash`: A bubble-wrap script used for running Nix on systems where it shouldn't be. See https://ersei.net/en/blog/its-nixin-time

### `/hosts`

Each of the devices that my configuration is setup to target.
Each host is a directory under `/hosts`, with the `default.nix` file defining the host.
In each of the hosts that I particularly care for is a `readme.org` file containing source blocks.
These source blocks are tangled to the respective bash scripts, which are used for provisioning a device with that configuration.

Summary of what the scripts do

- `prep.bash /path/to/dev/disk`: Partitions and formats the given disk.
- `install.bash /path/to/dev/disk`: Mounts the file systems, then runs all commands for an installation, including cloning the configuration into `/etc/nixos`
- `bare_install.bash`: Just runs `nixos-install`
- `mount.bash /path/to/dev/disk`: Mounts the file systems as in `install.bash`.
- `data_setup.bash /path/to/dev/disk`: Partitions the disk as a separate data storage; Used for Infini-SERVER.

### `/lib`

Nix library components.

- `default.nix`: All of the miscellaneous library functions I have defined for myself, as well as imports for the other library sections
- `digga.nix`: Import utilities stolen from the Digga library
- `disko.nix`: Shortcut functions for defining disk setups using Disko
- `filesystems.nix`: Shortcut functions for defining disk setups using filesystems
- `hosts.nix`: The `mkHost` function for importing NixOS hosts
- `options.nix`: Helper functions for quickly defining new options

### `/modules`

The real meat of the configuration, defines a bunch of NixOS modules that all get recursively imported;

#### `/modules/functionality`

Modules that create some sort of new functionality.

- `soft-serve.nix`: Runs the `soft-serve` git server.
- `ssh-tunnel.nix`: Runs an SSH session for opening ports.

#### `/modules/global`

Definitions that apply globally across all devices.

- `backup.nix`: Borg-backup-based automatic backups for all of my devices
- `boot.nix`: Sets up the bootloader. In my case: Grub.
- Each file in the `caches` folder is a definition for a binary cache.
- `common.nix`: Commonly reused definitions, through the `common` config option
- `defaults.nix`: Overrides NixOS defaults, on account of `stateVersion` changes
- `general.nix`: Broad general things that apply globally.
- `graphical.nix`: Global configuration that applies to graphical environments
- `home-manager.nix` defines default home-manager configurations that apply to all users
- `kmscon.nix`: Setup for my preferred TTY: kmscon.
- `locale.nix`: Sets up various locale-related things like keymap, compose key, timezone, etc.
- `networking.nix`: Networking related settings, such as setting up tailscale, avahi, and DNS.
- `nix.nix` defines Nix settings, like allowed users, garbage collection, etc. Also installs some Nix-related packages
- `options.nix` defines shortcut options used throughout the configuration.
- `packages.nix`: Packages that should be installed on everything.
- `persist.nix`: Global setup for my persistent impermanence folders, from my standard `/persist` folder.
- `security.nix`: Various security related settings.
- `shell.nix`: Shell-related settings like aliases.
- `ssh.nix`: SSH-related settings
- `virtualisation.nix`: Setup for virtualisation, namely docker and libvirtd

#### `/modules/modules`

Modules that simplify the setup of things between devices.
Differs from `global` in that they are gated behind options rather than applying globally.

- `desktop`: Things related to the desktop experience
  - `gaming.nix`: Sets up gaming related software
  - `wm.nix`: Sets up my window manager of choice: Qtile
- `hardware`: Modules that setup hardware
  - `audio.nix`: Sets up audio by enabling sound and enabling pipewire and related software.
  - `form.nix`: Settings that are form-specific. Forms are desktop, laptop, portable, raspberry pi, and server.
  - `gpu.nix`: GPU-specific settings, primarily with regards to setting up drivers and installing software necessary for hardware acceleration.
  - `wireless.nix`: Sets up wireless communication, namely WiFi and Bluetooth.
  - `peripherals`: Modules that setup peripherals like mice or printers.
    - `printing.nix`: Sets up printing with the printing service.
    - `yubikey.nix`: Sets up yubikey-related software and settings
- `services`: Sets up services.
  - `apcupsd.nix`: Sets up apcupsd to manage my UPS.

#### `/modules/vendored`

These are modules taken from Nixpkgs or elsewhere that I vendor into my configuration so I can make deeper changes to them, while not using import-from-derivation type patching. Usually to change it so I can set an explicit directory to store files in.

- `conduit.nix`: Modified to allow selecting a file storage location
- `factorio.nix`: Modified primarily to allow setting map generation settings
- `hydra.nix`: Modified to allow selecting a file storage location and specify an environment file.
- `jellyfin.nix`: Modified to allow selecting file storage locations
- `steam.nix`: Modified to put Steam's packages into user packages instead of system packages
- `thelounge.nix`: Modified to allow selecting a file storage location
- `vaultwarden.nix`: Modified to allow selecting a file storage location

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

- `bytecode-viewer.nix`: A viewer for Java bytecode
- `ears-cli.nix`: A CLI for working with Ears-format skins
- `fw-ectool.nix`: The ectool for Framework laptops
- `hexagon.nix`: A runner/compiler for Hex Casting spells.
- `mcaselector.nix`: A wrapper around the MCASelector jar so it runs on Nix.
- `nix-modrinth-prefetch.nix`: A prefetcher for Modrinth mods.
- `olympus.nix`: The olympus mod manager/installer for Celeste
- `sim65.nix`: The Sim65 65c02 simulator and debugger. Not well tested.
- `substitute-subset.nix`: `substituteAll` for a limited subset of files.
- `unbted.nix`: An NBT editor for Minecraft.

### `/secrets`

Contains and handles all secrets for the configuration.
Managed using `agenix`.

### `/shell`

Things related to the shell environment for this configuration.
Currently just provides `disko` and a Python environment with Qtile installed for editing the Qtile configuration.

### `/users`

The real meat behind my personal non-system configuration. Defines users of the system, including me.

#### `/users/modules`

Mirrors `/modules` in that it defines modules for use with home-manager.

##### `/users/modules/functionality`

Modules that add new home manager functionality.

- `bindmounts.nix`: A home-manager module modified from `impermanence`'s home manager module to setup bind mounts.

##### `/users/modules/global`

Home Manager gettings that are set globally.

- `direnv.nix`
- `flameshot.nix`
- `git.nix`
- `gpg.nix`
- `htop.nix`
- `keychain.nix`
- `kitty.nix`
- `mpris.nix`
- `neovim.nix`
- `obs-studio.nix`
- `programming.nix`: Packages/configuration for various programming languages.
- `rofi.nix`
- `shells`: Per-shell settings
  - `all.nix`: Imports all other shells
  - `common.nix`: Common things for all shells, imported by each shell
  - `bash.nix`
  - `fish.nix`
  - `ion.nix`
  - `nushell.nix`
  - `zsh.nix`
- `ssh.nix`
- `starship.nix`
- `theming.nix`
- `tmux.nix`
- `vim.nix`
- `zoxide.nix`

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
  - `qtile`: My Qtile configuration. Qtile is my home of homes, the environment I am pretty literally always in while on my computers.
