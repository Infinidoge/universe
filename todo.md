# TODO

- [ ] Import modules with haumea
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
- [ ] Figure out Minecraft OpenAL startup error (`aoss` as wrapper is a workaround)
- [ ] Backup postgres database as a borgbackup dump
- [ ] Add Xonsh
- [ ] Setup GNOME Keyring and Nheko
- [ ] Implement a copyparty auto-file hook to sort uploads into (Ref: https://github.com/9001/copyparty/blob/hovudstraum/bin/hooks/reloc-by-ext.py)

# Move to Wayland
- [ ] https://sr.ht/~emersion/kanshi/
- [ ] rofi -> wofi

# Provisioning scripts
- [ ] https://github.com/nix-community/disko
- [ ] Generate host SSH keys and rekey secrets
  - https://github.com/NixOS/nixpkgs/blob/1042fd8b148a9105f3c0aca3a6177fd1d9360ba5/nixos/modules/services/networking/ssh/sshd.nix#L561-L576
- [ ] Generate basic configuration in universe
- [ ] Install extras

# SSH keys revamp
- [ ] Put SSH host keys in host folders
- [ ] Automatically include host keys in known hosts file, with common connection points
- [ ] Use plaintext ssh keys file instead of nix file?

# Secrets revamp
- [ ] Collect host keys from host folders
- [ ] Bundle secrets with services?
- [ ] Bundle secrets with hosts?

# NixVim
- [ ] LSP support
- [ ] Fix Nix indenting
- [ ] Borrow from [Ersei's config](https://git.sr.ht/~fd/nix-configs/tree/main/item/home/common/nvim)
- [ ] Replace NixVim with LazyVim?

# Dendritic libraries

Look into

- https://github.com/vic/flake-file
- https://github.com/vic/import-tree/
- https://github.com/vic/den
- https://dendrix.oeiuwq.com/Dendritic-Ecosystem.html

Reimplement from scratch?
Possibly Foxy Software project?

# Issues pending fixes

