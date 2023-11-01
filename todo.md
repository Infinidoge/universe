# TODO

- [x] Move programming languages to home-manager
- [x] Add tool for `universe-cli cd`
- [ ] Import modules with haumea instead of digga lib
- [ ] Reorganize modules to separate ones defining options and ones providing config
  - Move config into global, move global into root?
  - Can do the same for home manager. Put NixOS ones under `nixos`, home manager under `home`?
- [ ] Add Nix-on-Droid config
- [ ] Declare Hydrus Companion extension in Firefox config
- [ ] Move `$EDITOR` script to a home-manager session variable
- [ ] Fix https://github.com/NixOS/nixpkgs/issues/45039

# Issues pending fixes

- [ ] Home Manager, "`optionsDocBook` is deprecated", https://github.com/nix-community/home-manager/issues/4273
- [ ] Home Manager, handle `use-xdg-base-directories`, https://github.com/nix-community/home-manager/issues/4593
