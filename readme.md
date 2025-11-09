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

- `addtovpn`: A helper script for provisioning keys for my wireguard VPN
- `bwrap.bash`: A bubble-wrap script used for running Nix on systems where it shouldn't be. See https://ersei.net/en/blog/its-nixin-time
- `format-json`: Simple script for formatting a json file in-place with jq
- `mapwacom`: A script to properly map a wacom tablet to a display

### `/hosts`

Each of the devices that my configuration is setup to target.
Each host is a directory under `/hosts`, with the `default.nix` file defining the host.

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

#### `/modules/modules`

Modules that simplify the setup of things between devices.
Differs from `global` in that they are gated behind options rather than applying globally.

#### `/modules/vendored`

These are modules taken from Nixpkgs or elsewhere that I vendor into my configuration so I can make deeper changes to them, while not using import-from-derivation type patching. Usually to change it so I can set an explicit directory to store files in.

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

### `/secrets`

Contains and handles all secrets for the configuration.
Managed using `agenix-rekey`.
`/secrets/generated` are generated and stored, `/secrets/rekeyed` are the secrets keyed per host.

Hosts and users have their own relevant secrets.

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
