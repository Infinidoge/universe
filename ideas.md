# Various ideas/Things I might do later

- Package/use [ALVR](https://github.com/alvr-org/alvr)
- Setup IRC (Possibly with ZNC)
- Add Speedcrunch configuration
- Add Polychromatic
- Reimplement Stretchly
- Add a rofi menu for running commands (Plus modifier key to open in shell)
- Declarative partition creation
  - [Disko](https://github.com/nix-community/disko) could be used
  - UUIDs can be generated using `uuidgen`. `uuidgen --md5 --namespace <UUID> --name <NAME>` is useful for deterministically generating UUIDs. Use the namespace to represent the computer itself, and the name to represent the partitions.
- Reconsider Avahi. Mostly redundant with tailscale handling most things, except when internet is down.
- Setup Nix LSP with [nil](https://github.com/oxalica/nil)
