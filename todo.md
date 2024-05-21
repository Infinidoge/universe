# TODO

- [x] Move programming languages to home-manager
- [x] Add tool for `universe-cli cd`
- [ ] Import modules with haumea
- [ ] Reorganize modules to separate ones defining options and ones providing config
  - Move config into global, move global into root?
  - Can do the same for home manager. Put NixOS ones under `nixos`, home manager under `home`?
- [ ] Add Nix-on-Droid config
- [ ] Declare Hydrus Companion extension in Firefox config
- [ ] Move `$EDITOR` script to a home-manager session variable
- [ ] Fix https://github.com/NixOS/nixpkgs/issues/45039
- [ ] Look into `thermald` for Framework
- [ ] Handle error codes in git-fzf and git-fzf-edit
- [ ] Remove networking scratchpad dropdown on non-wireless systems
- [ ] Hardware acceleration on Jellyfin
- [ ] Set fingerprint timeout to definite
- [ ] Look into `imv` image viewer
- [ ] Look into `broot` file search
- [ ] File Qtile bug report for clock timezone
- [ ] https://github.com/nix-community/nixvim
- [ ] Figure out Minecraft OpenAL startup error (`aoss` as wrapper is a workaround)
- [ ] Backup postgres database as a borgbackup dump
- [ ] Add Xonsh

# Move to Wayland
- [ ] https://sr.ht/~emersion/kanshi/
- [ ] rofi -> wofi

# Provisioning scripts
- [ ] https://github.com/nix-community/disko
- [ ] Generate host SSH keys and rekey secrets
  - https://github.com/NixOS/nixpkgs/blob/1042fd8b148a9105f3c0aca3a6177fd1d9360ba5/nixos/modules/services/networking/ssh/sshd.nix#L561-L576
- [ ] Generate basic configuration in universe
- [ ] Install extras like doom

# SSH keys revamp
- [ ] Put SSH host keys in host folders
- [ ] Automatically include host keys in known hosts file, with common connection points
- [ ] Use plaintext ssh keys file instead of nix file?

# Secrets revamp
- [ ] Collect host keys from host folders
- [ ] Bundle secrets with services?
- [ ] Bundle secrets with hosts?

# Certificate Authority
- [ ] SSH CA
  - https://vriska.dev/trusting-ssh-keys-using-a-centralized-hardware-secret/
- [ ] SSL CA
- [ ] Signing server?

# Issues pending fixes

